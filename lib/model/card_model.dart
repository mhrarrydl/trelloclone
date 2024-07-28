import 'package:tutero_test/config/constants/key_constants.dart';

class CardModel {
  final int id;
  final String title;
  final DateTime dateCreated;
  final String? imagePath;

  CardModel({
    required this.id,
    required this.title,
    required this.dateCreated,
    this.imagePath = '',
  });

  CardModel.fromJson(Map<String, dynamic> map)
      : id = map[keyId],
        title = map[keyTitle],
        dateCreated = map[keyDateCreated],
        imagePath = map.containsKey(keyImagePath) ? map[keyImagePath] : '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> resultMap = {};
    resultMap[keyId] = id;
    resultMap[keyTitle] = title;
    resultMap[keyDateCreated] = dateCreated;
    resultMap[keyImagePath] = imagePath;
    return resultMap;
  }
}
