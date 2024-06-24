import 'dart:typed_data';

class BinaryReader {
  final Uint8List _buffer;
  final ByteData _view;
  var _offset = 0;

  BinaryReader(this._buffer) : _view = ByteData.view(_buffer.buffer);

  void _checkBufferLimit(int bytes) {
    assert(_offset + bytes <= _buffer.length);
  }

  void skip(int bytes) {
    _checkBufferLimit(bytes);
    _offset += bytes;
  }

  int readByte() {
    _checkBufferLimit(1);
    return _buffer[_offset++];
  }

  Uint8List readBytes(int lenght) {
    _checkBufferLimit(lenght);
    final val = _buffer.sublist(_offset, _offset + lenght);
    _offset += lenght;
    return val;
  }

  int readUint8() {
    _checkBufferLimit(1);
    final val = _view.getUint8(_offset);
    _offset += 1;
    return val;
  }

  int readUint16() {
    _checkBufferLimit(2);
    final val = _view.getUint16(_offset, Endian.little);
    _offset += 2;
    return val;
  }

  int readUint32() {
    _checkBufferLimit(4);
    final val = _view.getUint32(_offset, Endian.little);
    _offset += 4;
    return val;
  }

  int readUint64() {
    _checkBufferLimit(8);
    final val = _view.getUint64(_offset, Endian.little);
    _offset += 8;
    return val;
  }

  int readInt8() {
    _checkBufferLimit(1);
    final val = _view.getInt8(_offset);
    _offset += 1;
    return val;
  }

  int readInt16() {
    _checkBufferLimit(2);
    final val = _view.getInt16(_offset, Endian.little);
    _offset += 2;
    return val;
  }

  int readInt32() {
    _checkBufferLimit(4);
    final val = _view.getInt32(_offset, Endian.little);
    _offset += 4;
    return val;
  }

  int readInt64() {
    _checkBufferLimit(8);
    final val = _view.getInt64(_offset, Endian.little);
    _offset += 8;
    return val;
  }

  double readFloat32() {
    _checkBufferLimit(4);
    final val = _view.getFloat32(_offset, Endian.little);
    _offset += 4;
    return val;
  }

  double readFloat64() {
    _checkBufferLimit(8);
    final val = _view.getFloat64(_offset, Endian.little);
    _offset += 8;
    return val;
  }
}
