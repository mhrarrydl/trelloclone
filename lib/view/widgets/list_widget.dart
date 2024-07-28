import 'package:flutter/material.dart';
import 'package:tutero_test/config/constants/key_constants.dart';
import 'package:tutero_test/model/list_model.dart';
import 'package:tutero_test/view/widgets/card_widget.dart';
import 'package:tutero_test/view/widgets/hover_placeholder_widget.dart';
import 'package:tutero_test/view_model/board_view_model.dart';
// import 'dart:developer' as devtools show log;

class ListWidget extends StatelessWidget {
  final ListModel list;
  final int listIndex;
  final BoardViewModel _viewModel;

  const ListWidget({
    required this.list,
    required this.listIndex,
    required BoardViewModel viewModel,
    super.key,
  }) : _viewModel = viewModel;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Map<String, int>>(
      data: {keyAppFromListIndex: listIndex},
      feedback: SizedBox(
        width: 300,
        child: Card(
          color: Colors.blue.withOpacity(0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  list.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              for (var card in list.cards)
                ListTile(
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
            ],
          ),
        ),
      ),
      childWhenDragging: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              width: 300,
              color: Colors.grey,
            ),
          )
        ],
      ),
      child: DragTarget<Map<String, int>>(
        hitTestBehavior: HitTestBehavior.opaque,
        onAcceptWithDetails: (details) {
          // Checking if the details data is of List data type
          if (!details.data.containsKey(keyAppFromCardIndex)) {
            var fromListIndex = details.data[keyAppFromListIndex]!;
            var toListIndex = listIndex;
            _viewModel.moveList(fromListIndex, toListIndex);
          }
          //  else {
          //   devtools.log("ListData: ${details.data}, listIndex: $listIndex");
          // }
        },
        onWillAcceptWithDetails: willAcceptDetails,
        builder: (context, acceptedData, rejectedData) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: 300,
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _viewModel.removeList(listIndex);
                          },
                        ),
                      ],
                    ),
                    DragTarget<Map<String, int>>(
                      onWillAcceptWithDetails: willAcceptDetails,
                      onAcceptWithDetails: (details) {
                        var data = details.data;
                        // Checking if the details data is of card data type
                        if (details.data.containsKey(keyAppFromCardIndex) &&
                            (data[keyAppFromListIndex] != listIndex)) {
                          _viewModel.moveCard(
                            fromListIndex: data[keyAppFromListIndex]!,
                            fromCardIndex: data[keyAppFromCardIndex]!,
                            toListIndex: listIndex,
                            toCardIndex: list.cards.length,
                          );
                        }
                      },
                      builder: (context, acceptedCards, rejectedCards) {
                        bool isHovering = acceptedCards.isNotEmpty;
                        // if (isHovering) {
                        //   devtools.log(
                        //       "${acceptedCards.first}, listIndex: $listIndex");
                        // }
                        // if (acceptedData.isNotEmpty &&
                        //     acceptedData.first![keyAppToCardIndex] == 0) {
                        //   devtools.log("Entered");
                        // }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((isHovering &&
                                    acceptedCards.first![keyAppToCardIndex] ==
                                        0) ||
                                acceptedData.isNotEmpty &&
                                    acceptedData.first![keyAppToCardIndex] == 0)
                              const HoveringPlaceHolder(),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.cards.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {}
                                return CardWidget(
                                  viewModel: _viewModel,
                                  card: list.cards[index],
                                  listIndex: listIndex,
                                  cardIndex: index,
                                );
                              },
                            ),
                            if (isHovering &&
                                acceptedCards.first![keyAppToCardIndex] ==
                                    list.cards.length &&
                                list.cards.isNotEmpty)
                              const HoveringPlaceHolder(),
                            const SizedBox(height: 20),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _showAddCardDialog(context),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DragTarget<Map<String, int>>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(width: 300);
                  },
                  onWillAcceptWithDetails: (details) {
                    var data = details.data;
                    return data.containsKey(keyAppFromCardIndex);
                  },
                  onAcceptWithDetails: (details) {
                    var data = details.data;
                    // Checking if the details data is of card data type
                    if (details.data.containsKey(keyAppFromCardIndex) &&
                        (data[keyAppFromListIndex] != listIndex)) {
                      _viewModel.moveCard(
                        fromListIndex: data[keyAppFromListIndex]!,
                        fromCardIndex: data[keyAppFromCardIndex]!,
                        toListIndex: listIndex,
                        toCardIndex: list.cards.length,
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool willAcceptDetails(details) {
    var data = details.data;
    if (data.containsKey(keyAppFromCardIndex)) {
      if (list.cards.isEmpty ||
          (
              // list.cards.length == 1 &&
              data[keyAppFromCardIndex] == 0 &&
                  data[keyAppFromListIndex] == listIndex)) {
        details.data[keyAppToCardIndex] = 0;
      } else {
        details.data[keyAppToCardIndex] = list.cards.length;
      }
      return true;
    } else {
      return true;
    }
  }

  void _showAddCardDialog(BuildContext context) {
    String cardTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Card'),
          content: TextField(
            onChanged: (value) {
              cardTitle = value;
            },
            decoration: const InputDecoration(hintText: "Card Title"),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (cardTitle.isNotEmpty) {
                  _viewModel.addCard(listIndex, cardTitle);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
