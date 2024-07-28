import 'package:flutter/material.dart';
import 'package:tutero_test/model/card_model.dart';
import 'package:tutero_test/model/list_model.dart';

class BoardViewModel extends ChangeNotifier {
  final List<ListModel> _lists = [
    ListModel(
      title: 'To do',
      cards: [
        CardModel(
          title: 'Hi',
          dateCreated: DateTime.now(),
          id: 121,
        ),
      ],
      id: 1,
    ),
    ListModel(
      title: 'Completed',
      cards: [
        CardModel(
          title: 'Hello1',
          dateCreated: DateTime.now(),
          id: 122,
        ),
        CardModel(
          title: 'Hello2',
          dateCreated: DateTime.now(),
          id: 122,
        ),
        CardModel(
          title: 'Hello3',
          dateCreated: DateTime.now(),
          id: 122,
        ),
        CardModel(
          title: 'Hello4',
          dateCreated: DateTime.now(),
          id: 122,
        ),
        CardModel(
          title: 'Hello5',
          dateCreated: DateTime.now(),
          id: 122,
        ),
        CardModel(
          title: 'Hello6',
          dateCreated: DateTime.now(),
          id: 122,
        ),
        CardModel(
          title: 'Hello7',
          dateCreated: DateTime.now(),
          id: 122,
        ),
        CardModel(
          title: 'Hello8',
          dateCreated: DateTime.now(),
          id: 122,
        ),
        CardModel(
          title: 'Hello9',
          dateCreated: DateTime.now(),
          id: 122,
        ),
      ],
      id: 2,
    ),
    ListModel(
      title: 'Backlog',
      cards: [],
      id: 3,
    ),
  ];

  List<ListModel> get lists => _lists;

  void addList(String title) {
    final id = DateTime.now().millisecondsSinceEpoch.abs();
    _lists.add(
      ListModel(
        title: title,
        cards: [],
        id: id,
      ),
    );
    notifyListeners();
  }

  void removeList(int index) {
    _lists.removeAt(index);
    notifyListeners();
  }

  void moveList(int fromListIndex, int toListIndex) {
    final list = _lists.removeAt(fromListIndex);
    _lists.insert(toListIndex, list);
    notifyListeners();
  }

  void addCard({
    required int listIndex,
    required String title,
    String? imagePath,
  }) {
    _lists[listIndex].addCard(
      listIndex: listIndex,
      title: title,
      imagePath: imagePath,
    );
    notifyListeners();
  }

  void removeCard(int listIndex, int cardIndex) {
    _lists[listIndex].removeCard(cardIndex);
    notifyListeners();
  }

  void moveCard({
    required int fromListIndex,
    required int fromCardIndex,
    int? toListIndex,
    int? toCardIndex,
  }) {
    final card = _lists[fromListIndex].removeCard(fromCardIndex);
    final listIndex = toListIndex ?? fromListIndex;
    final cardIndex = toCardIndex ?? fromCardIndex;
    _lists[listIndex].cards.insert(cardIndex, card);
    notifyListeners();
  }
}
