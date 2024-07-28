import 'package:tutero_test/config/constants/key_constants.dart';

import 'card_model.dart';

class ListModel {
  final int id;
  final String title;
  final List<CardModel> cards;

  ListModel({
    required this.id,
    required this.title,
    required this.cards,
  });

  ListModel.fromJson(Map<String, dynamic> map)
      : id = map[keyId],
        title = map[keyTitle],
        cards = map[keyCards];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> resultMap = {};
    resultMap[keyId] = id;
    resultMap[keyTitle] = title;
    resultMap[keyCards] = cards;
    return resultMap;
  }

  void addCard({
    required int listIndex,
    required String title,
    String? imagePath,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.abs();
    cards.add(
      CardModel(
        title: title,
        dateCreated: DateTime.now(),
        id: id,
        imagePath: imagePath,
      ),
    );
  }

  CardModel removeCard(int cardIndex) {
    return cards.removeAt(cardIndex);
  }
}
