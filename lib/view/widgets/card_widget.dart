import 'package:flutter/material.dart';
import 'package:tutero_test/config/constants/key_constants.dart';
import 'package:tutero_test/model/card_model.dart';
import 'package:tutero_test/view_model/board_view_model.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final int listIndex;
  final int cardIndex;
  final BoardViewModel _viewModel;

  const CardWidget({
    required this.card,
    required this.listIndex,
    required this.cardIndex,
    required BoardViewModel viewModel,
    super.key,
  }) : _viewModel = viewModel;

  @override
  Widget build(BuildContext context) {
    return Draggable<Map<String, int>>(
      data: {keyAppFromListIndex: listIndex, keyAppFromCardIndex: cardIndex},
      feedback: SizedBox(
        width: 280,
        child: Card(
          color: Colors.blue.withOpacity(0.8),
          child: ListTile(
            title: Text(
              card.title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              card.dateCreated.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(),
      child: DragTarget<Map<String, int>>(
        hitTestBehavior: HitTestBehavior.opaque,
        onAcceptWithDetails: (details) {
          var data = details.data;
          if (data.containsKey(keyAppFromCardIndex)) {
            _viewModel.moveCard(
              fromListIndex: data[keyAppFromListIndex]!,
              fromCardIndex: data[keyAppFromCardIndex]!,
              toListIndex: listIndex,
              toCardIndex: cardIndex,
            );
          }
        },
        builder: (context, acceptedData, rejectedData) {
          return Card(
            child: ListTile(
              title: Text(card.title),
              subtitle: Text(card.dateCreated.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _viewModel.removeCard(
                  listIndex,
                  cardIndex,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
