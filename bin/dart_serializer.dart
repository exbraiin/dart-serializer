import 'package:dart_serializer/dart_serializer.dart';

void main(List<String> arguments) async {
  BinaryBox.init('boxes');
  final boxInt = await BinaryBox.openBox<int>('my_int_box');
  final boxListInt = await BinaryBox.openBox<List<int>>('my_int_list_box');

  // await boxInt.set('my_int', 1);
  print(boxInt.get('my_int'));

  // await boxListInt.set('my_obj', [1, 2, 3, 4, 5]);
  print(boxListInt.get('my_obj'));
}
