import 'package:flutter/material.dart';
import 'package:cacai/model/insect.dart';

class InsectSearch extends SearchDelegate<String> {
  final List<Insect> insects;

  InsectSearch(this.insects);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.teal),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.teal),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = insects.where(
        (insect) => insect.name.toLowerCase().contains(query.toLowerCase()));

    if (results.isEmpty) {
      return const Center(
          child:
              Text('No results found.', style: TextStyle(color: Colors.teal)));
    }

    return ListView(
      children: results
          .map<ListTile>((insect) => ListTile(
                tileColor:
                    Colors.teal.shade50, // Light teal background for each item
                title: Text(
                  insect.name,
                  style: const TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  insect.description,
                  style: TextStyle(color: Colors.teal[700]),
                ),
                onTap: () {
                  showResults(context);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = insects.where(
        (insect) => insect.name.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: suggestions
          .map<ListTile>((insect) => ListTile(
                tileColor: Colors
                    .teal.shade50, // Light teal background for suggestions
                title: Text(
                  insect.name,
                  style: const TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  insect.description,
                  style: TextStyle(color: Colors.teal[700]),
                ),
                onTap: () {
                  query = insect.name;
                  showResults(context);
                },
              ))
          .toList(),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.teal, // Primary color for the search bar
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.teal.shade400),
      ),
    );
  }
}
