import 'dart:convert';

import 'package:dart_serializer/dart_serializer.dart';

extension BinaryWriterDartExt on BinaryWriter {
  void writeInt(int obj) {
    writeInt64(obj);
  }

  void writeBool(bool obj) {
    writeByte(obj ? 1 : 0);
  }

  void writeDouble(double obj) {
    writeFloat64(obj);
  }

  void writeString(String obj, [Utf8Encoder encoder = const Utf8Encoder()]) {
    final encoded = encoder.convert(obj);
    writeUint32(encoded.length);
    writeBytes(encoded);
  }

  void writeDuration(Duration obj) {
    writeUint32(obj.inMicroseconds);
  }

  void writeDateTime(DateTime obj) {
    writeUint32(obj.microsecondsSinceEpoch);
  }
}

extension BinaryReaderDartExt on BinaryReader {
  int readInt() {
    return readInt64();
  }

  bool readBool() {
    return readByte() > 0;
  }

  double readDouble() {
    return readFloat64();
  }

  String readString([Utf8Decoder decoder = const Utf8Decoder()]) {
    final lenght = readUint32();
    final bytes = readBytes(lenght);
    return decoder.convert(bytes);
  }

  Duration readDuration() {
    return Duration(microseconds: readUint32());
  }

  DateTime readDateTime() {
    return DateTime.fromMicrosecondsSinceEpoch(readUint32());
  }
}
