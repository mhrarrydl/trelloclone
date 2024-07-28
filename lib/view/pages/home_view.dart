import 'package:flutter/material.dart';
import 'package:tutero_test/view/widgets/list_widget.dart';
import 'package:tutero_test/view_model/board_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scrollController = ScrollController();
  late final BoardViewModel _viewModel;

  @override
  void initState() {
    _viewModel = BoardViewModel();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Trello'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddListDialog(context),
          ),
        ],
      ),
      body: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            return Scrollbar(
              controller: _scrollController,
              interactive: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 2),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    _viewModel.lists.length,
                    (index) {
                      return ListWidget(
                        list: _viewModel.lists[index],
                        listIndex: index,
                        viewModel: _viewModel,
                      );
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _showAddListDialog(BuildContext context) {
    String listTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add List'),
          content: TextField(
            onChanged: (value) {
              listTitle = value;
            },
            decoration: const InputDecoration(hintText: "List Title"),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (listTitle.isNotEmpty) {
                  _viewModel.addList(listTitle);
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