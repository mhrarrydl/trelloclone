import 'package:flutter/material.dart';
import 'package:tutero_test/config/constants/key_constants.dart';
import 'package:tutero_test/model/card_model.dart';
import 'package:tutero_test/view/widgets/hover_placeholder_widget.dart';
import 'package:tutero_test/view_model/board_view_model.dart';
// import 'dart:developer' as devtools show log;

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
          // Checking if the details data is of card data type
          if (data.containsKey(keyAppFromCardIndex)) {
            _viewModel.moveCard(
              fromListIndex: data[keyAppFromListIndex]!,
              fromCardIndex: data[keyAppFromCardIndex]!,
              toListIndex: listIndex,
              toCardIndex: cardIndex,
            );
          }
        },
        onWillAcceptWithDetails: (details) {
          var data = details.data;
          return data.containsKey(keyAppFromCardIndex);
        },
        builder: (context, acceptedData, rejectedData) {
          bool isHovering = acceptedData.isNotEmpty;
          bool isIndexBefore = false;
          if (isHovering) {
            var fromCardIndex = acceptedData.first![keyAppFromCardIndex]!;
            var fromListIndex = acceptedData.first![keyAppFromListIndex]!;
            isIndexBefore = (
                // The card index is 1 less or 2 less or lesser than fromCardIndex
                listIndex == fromListIndex && cardIndex <= fromCardIndex - 1 ||
                    cardIndex <= fromCardIndex - 2 ||
                    // The card index is more than, equal to, or less than fromCardIndex but in a different list
                    (listIndex != fromListIndex &&
                        (cardIndex >= fromCardIndex ||
                            cardIndex == fromCardIndex ||
                            cardIndex < fromCardIndex)));
          }

          // if (isHovering) {
          //   devtools.log(
          //       "${acceptedData.first}, cardIndex: $cardIndex, listIndex: $listIndex");
          // }
          return Column(
            children: [
              if (isHovering && isIndexBefore) const HoveringPlaceHolder(),
              Card(
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
              ),
              if (isHovering && !isIndexBefore) const HoveringPlaceHolder(),
            ],
          );
        },
      ),
    );
  }
}
