import 'package:flutter/material.dart';
import 'package:tutero_test/config/constants/key_constants.dart';
import 'package:tutero_test/config/utils/utility.dart';
import 'package:tutero_test/model/card_model.dart';
import 'package:tutero_test/view/widgets/hover_card_placeholder_widget.dart';
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
              Utility().formatDate(card.dateCreated),
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
            isIndexBefore =
                (listIndex == fromListIndex && cardIndex <= fromCardIndex - 1 ||
                    cardIndex <= fromCardIndex - 2 ||
                    (listIndex != fromListIndex &&
                        (cardIndex >= fromCardIndex ||
                            cardIndex == fromCardIndex ||
                            cardIndex < fromCardIndex)));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isHovering && isIndexBefore) const HoveringCardPlaceHolder(),
              Stack(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (card.imagePath != null &&
                            card.imagePath!.isNotEmpty)
                          AspectRatio(
                            aspectRatio: 16 / 7,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Container(
                                color: Colors.grey.shade400,
                                child: Image.network(
                                  card.imagePath!,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Utility().formatDate(card.dateCreated)),
                              const SizedBox(height: 5),
                              Text(
                                card.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 7,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _viewModel.removeCard(
                        listIndex,
                        cardIndex,
                      ),
                    ),
                  )
                ],
              ),
              if (isHovering && !isIndexBefore) const HoveringCardPlaceHolder(),
            ],
          );
        },
      ),
    );
  }
}
