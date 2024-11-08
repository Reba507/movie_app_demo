import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/item_bloc.dart';
import 'bloc/item_event.dart';
import 'bloc/item_state.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Example',
      home: BlocProvider(
        create: (context) => ItemBloc(ApiService(
            'http://www.omdbapi.com/apikey.aspx?VERIFYKEY=d485b541-f314-413a-ba99-8d7578bff06c')),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Pattern Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final query = _controller.text;
                    BlocProvider.of<ItemBloc>(context).add(FetchItems(query));
                  },
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  if (state is ItemLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ItemLoaded) {
                    return ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ListTile(
                          title: Text(item['title']),
                        );
                      },
                    );
                  } else if (state is ItemError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('Search for items'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
