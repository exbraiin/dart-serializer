import 'dart:typed_data';

class BinaryWriter {
  final _bytes = <int>[];
  final _view = ByteData(8);

  Uint8List get bytes => Uint8List.fromList(_bytes);

  void writeByte(int byte) {
    _bytes.add(byte);
  }

  void writeBytes(Uint8List bytes) {
    _bytes.addAll(bytes);
  }

  void writeUint8(int value) {
    _view.setUint8(0, value);
    _bytes.addAll(_view.buffer.asUint8List().take(1));
  }

  void writeUint16(int value) {
    _view.setUint16(0, value, Endian.little);
    _bytes.addAll(_view.buffer.asUint8List().take(2));
  }

  void writeUint32(int value) {
    _view.setUint32(0, value, Endian.little);
    _bytes.addAll(_view.buffer.asUint8List().take(4));
  }

  void writeUint64(int value) {
    _view.setUint64(0, value, Endian.little);
    _bytes.addAll(_view.buffer.asUint8List().take(8));
  }

  void writeInt8(int value) {
    _view.setInt8(0, value);
    _bytes.addAll(_view.buffer.asUint8List().take(1));
  }

  void writeInt16(int value) {
    _view.setInt16(0, value, Endian.little);
    _bytes.addAll(_view.buffer.asUint8List().take(2));
  }

  void writeInt32(int value) {
    _view.setInt32(0, value, Endian.little);
    _bytes.addAll(_view.buffer.asUint8List().take(4));
  }

  void writeInt64(int value) {
    _view.setInt64(0, value, Endian.little);
    _bytes.addAll(_view.buffer.asUint8List().take(8));
  }

  void writeFloat32(double value) {
    _view.setFloat32(0, value, Endian.little);
    _bytes.addAll(_view.buffer.asUint8List().take(4));
  }

  void writeFloat64(double value) {
    _view.setFloat64(0, value, Endian.little);
    _bytes.addAll(_view.buffer.asUint8List().take(8));
  }
}
