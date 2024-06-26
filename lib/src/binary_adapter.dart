import 'package:dart_serializer/src/serializers/binary_reader.dart';
import 'package:dart_serializer/src/serializers/binary_writer.dart';

typedef ValueReader<T> = T Function(BinaryReader reader);
typedef ValueWriter<T> = void Function(BinaryWriter writer, T obj);

abstract class BinaryAdapter<T> {
  T read(BinaryReader reader);
  void write(BinaryWriter writer, T obj);
}

class BinaryAdapterWrapper<T> extends BinaryAdapter<T> {
  final ValueReader<T> reader;
  final ValueWriter<T> writer;

  BinaryAdapterWrapper({
    required this.writer,
    required this.reader,
  });

  @override
  T read(BinaryReader reader) {
    return this.reader.call(reader);
  }

  @override
  void write(BinaryWriter writer, T obj) {
    return this.writer.call(writer, obj);
  }
}
