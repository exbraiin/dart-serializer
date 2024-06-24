import 'dart:math';

import 'package:dart_serializer/dart_serializer.dart';

void main(List<String> arguments) async {
  BinaryBox.init('boxes');

  // final box = await BinaryBox.openBox<int>('test_out');
  final li = await BinaryBox.openBox<List<int>>('my_int_box');
  final ls = await BinaryBox.openBox<List<String>>('my_string_box');

  /*
  print(ls.get('ls0'));
  print(ls.get('ls1'));
  print(ls.get('ls2'));
  */

  li.set('ls0', [1, 2, 3]);
  li.setAll({
    'ls1': [4, 5, 6],
    'ls2': [7, 8, 9],
  });
  ls.set('ls0', ['1', '2', '3']);
  ls.setAll({
    'ls1': ['4', '5', '6'],
    'ls2': ['7', '8', '9'],
  });
  print(li.getAll({'ls0'}));
  print(ls.getAll({'ls0'}));

  // box.set('my_int', 23);

  // print(box.get('my_int'));
  // print(ls.get('hmm'));

  // _randomTests();
}

typedef _Test = (
  int,
  int,
  List<int>,
  void Function(BinaryWriter, int),
  int Function(BinaryReader),
);

void _randomTests() async {
  final bounds = <_Test>[
    (
      0,
      256,
      <int>[],
      (b, i) => b.writeUint8(i),
      (r) => r.readUint8(),
    ),
    (
      0,
      65535,
      <int>[],
      (b, i) => b.writeUint16(i),
      (r) => r.readUint16(),
    ),
    (
      0,
      4294967295,
      <int>[],
      (b, i) => b.writeUint32(i),
      (r) => r.readUint32(),
    ),
    (
      0,
      4294967295, //9223372036854775807,
      <int>[],
      (b, i) => b.writeUint64(i),
      (r) => r.readUint64(),
    ),
    (
      -128,
      127,
      <int>[],
      (b, i) => b.writeInt8(i),
      (r) => r.readInt8(),
    ),
    (
      -32768,
      32767,
      <int>[],
      (b, i) => b.writeInt16(i),
      (r) => r.readInt16(),
    ),
    (
      -2147483648,
      2147483647,
      <int>[],
      (b, i) => b.writeInt32(i),
      (r) => r.readInt32(),
    ),
    (
      -4294967296,
      4294967295, //9223372036854775807,
      <int>[],
      (b, i) => b.writeInt64(i),
      (r) => r.readInt64(),
    ),
  ];

  final rand = Random();
  final bw = BinaryWriter();
  for (final bound in bounds) {
    if (bound.$1 < 0) {
      for (var i = 0; i < 1000; ++i) {
        final v = -rand.nextInt(bound.$1.abs());
        bound.$3.add(v);
        bound.$4.call(bw, v);
      }
    }
    for (var i = 0; i < 1000; ++i) {
      final v = rand.nextInt(bound.$2);
      bound.$3.add(v);
      bound.$4.call(bw, v);
    }
  }

  // await File('data.bin').writeAsBytes(bw.bytes);

  final br = BinaryReader(bw.bytes);
  boundsLoop:
  for (final bound in bounds) {
    for (final v in bound.$3) {
      final n = bound.$5.call(br);
      if (v != n) {
        print('Expected $v found $n');
        break boundsLoop;
      }
    }
  }
  print('Complete!');
}
