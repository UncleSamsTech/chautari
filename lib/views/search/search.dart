import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios));
    final searchBarColor = Color(0xffF8FAFC);

    final yourLastSearch = ["Happysispex", "tawangmangu", "Miho meninggoy"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  backButton,
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: searchBarColor),
                      child: TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search)),
                          textAlignVertical: TextAlignVertical.center),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: SearchSuggestion(
                searchHistory: yourLastSearch,
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class SearchSuggestion extends StatefulWidget {
  const SearchSuggestion({super.key, required this.searchHistory});

  final List<String> searchHistory;

  @override
  State<SearchSuggestion> createState() => _SearchSuggestionState();
}

class _SearchSuggestionState extends State<SearchSuggestion> {
  late List<String> searchHistory;

  @override
  void initState() {
    searchHistory = widget.searchHistory;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.searchHistory.isEmpty
          ? Center(
              child: Text("No search found"),
            )
          : Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(
                      "Your last search",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.delete_outline))
                  ],
                ),
                ...searchHistory.map((e) => ListTile(
                      leading: Icon(Icons.history),
                      title: Text(e),
                      trailing:
                          IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                    ))
              ],
            ),
    );
  }
}
