import 'dart:io';

import 'package:dart_serializer/dart_serializer.dart';

abstract final class BinaryBox<T> {
  static var _path = '';
  static final _boxes = <String, BinaryBox>{};
  static final _adapters = <Type, BinaryAdapter>{};

  static void init([String path = '.']) {
    if (_path.isNotEmpty) return;
    _path = path;
    registerWrapper<int>(
      reader: (r) => r.readInt(),
      writer: (w, o) => w.writeInt(o),
    );
    registerWrapper<bool>(
      reader: (r) => r.readBool(),
      writer: (w, o) => w.writeBool(o),
    );
    registerWrapper<double>(
      reader: (r) => r.readFloat64(),
      writer: (w, o) => w.writeFloat64(o),
    );
    registerWrapper<String>(
      reader: (r) => r.readString(),
      writer: (w, o) => w.writeString(o),
    );
    registerWrapper<Duration>(
      reader: (r) => r.readDuration(),
      writer: (w, o) => w.writeDuration(o),
    );
    registerWrapper<DateTime>(
      reader: (r) => r.readDateTime(),
      writer: (w, o) => w.writeDateTime(o),
    );
  }

  static void registerAdapter<T>(
    BinaryAdapter<T> adapter, {
    bool collections = true,
  }) {
    if (T == dynamic) {
      throw BinaryAdapterDynamic();
    }
    if (_adapters.containsKey(T)) {
      throw BinaryAdapterAlreadyRegistered<T>();
    }
    _adapters[T] = adapter;
    if (!collections) return;
    _registerCollection<T, Set<T>>(adapter, (l) => l.toSet());
    _registerCollection<T, List<T>>(adapter, (l) => l);
    _registerCollection<T, Iterable<T>>(adapter, (l) => l);
  }

  static void registerWrapper<T>({
    bool collections = true,
    required T Function(BinaryReader r) reader,
    required void Function(BinaryWriter w, T o) writer,
  }) {
    registerAdapter(
      BinaryAdapterWrapper<T>(writer: writer, reader: reader),
      collections: collections,
    );
  }

  static void _registerCollection<T, C extends Iterable<T>>(
    BinaryAdapter<T> adapter,
    C Function(List<T> l) converter,
  ) {
    registerAdapter(
      BinaryAdapterWrapper<C>(
        reader: (r) {
          final len = r.readUint32();
          return converter(List.generate(len, (_) => adapter.read(r)));
        },
        writer: (w, o) {
          w.writeUint32(o.length);
          for (final item in o) {
            adapter.write(w, item);
          }
        },
      ),
      collections: false,
    );
  }

  static Future<DataBox<E>> openBox<E>(String name) async {
    var box = _boxes[name];
    if (box == null) {
      final path = '${_path.replaceAll('\\', '/')}/$name.box';
      box = DataBox<E>._(path);
      await box._load();
    }
    return box as DataBox<E>;
  }

  Future<void> _load();

  T _read(BinaryReader reader) {
    final adapter = _adapters[T];
    if (adapter == null) {
      throw BinaryAdapterNotFound<T>();
    }
    return adapter.read(reader) as T;
  }

  void _write(BinaryWriter writer, T obj) {
    final adapter = _adapters[T];
    if (adapter == null) {
      throw BinaryAdapterNotFound<T>();
    }
    return adapter.write(writer, obj);
  }
}

final class DataBox<T> extends BinaryBox<T> {
  final File file;
  final _objects = <String, T>{};

  DataBox._(String path) : file = File(path);

  @override
  Future<void> _load() async {
    if (!await file.exists()) {
      await file.parent.create(recursive: true);
      await file.create();
      return;
    }
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return;
    final reader = BinaryReader(bytes);
    final length = reader.readUint32();
    for (var i = 0; i < length; ++i) {
      final key = reader.readString();
      _objects[key] = _read(reader);
    }
  }

  T? get(String key) {
    return _objects[key];
  }

  Map<String, T?> getAll([Set<String>? keys]) {
    if (keys == null) return Map.from(_objects);
    return Map.fromEntries(keys.map((e) => MapEntry(e, get(e))));
  }

  Future<void> set(String key, T obj) {
    _objects[key] = obj;
    return _postWrite();
  }

  Future<void> setAll(Map<String, T> map) {
    _objects.addAll(map);
    return _postWrite();
  }

  Future<void> clear() {
    _objects.clear();
    return _postWrite();
  }

  Future<void> _postWrite() async {
    final writer = BinaryWriter();
    final length = _objects.length;
    writer.writeUint32(length);
    for (final entry in _objects.entries) {
      writer.writeString(entry.key);
      _write(writer, entry.value);
    }
    await file.writeAsBytes(writer.bytes);
  }
}
