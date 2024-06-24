abstract class BinaryException implements Exception {
  final String message;

  BinaryException(this.message);

  @override
  String toString() => message;
}

class BinaryAdapterNotFound<T> extends BinaryException {
  BinaryAdapterNotFound() : super('Could not find Adapter<$T>!');
}

class BinaryAdapterAlreadyRegistered<T> extends BinaryException {
  BinaryAdapterAlreadyRegistered() : super('Adapter<$T> already registered!');
}

class BinaryAdapterDynamic extends BinaryException {
  BinaryAdapterDynamic() : super('Dont register dynamic adapters!');
}
