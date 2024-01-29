import 'package:flutter/material.dart';
import 'package:ebook/src/settings/settings_controller.dart';
import 'package:ebook/src/models/books.dart';
import 'package:ebook/src/pages/detail/detail.dart';
import 'package:ebook/src/api.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  void _onSearchSubmitted(String searchTerm, BuildContext context) {
    // Navigate to the search page with the entered search term
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          searchTerm: searchTerm,
          settingsController: settingsController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                  onSubmitted: (searchTerm) =>
                      _onSearchSubmitted(searchTerm, context),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      prefixIcon: const Icon(
                        Icons.search_outlined,
                        color: Color(0xFF6741FF),
                      ),
                      hintText: 'Search book here..'),
                  cursorColor: Color(0xFF6741FF))),
          IconButton(
            onPressed: () {
              settingsController.updateThemeMode(
                  settingsController.themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light);
            },
            icon: Icon(settingsController.themeMode == ThemeMode.light
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded),
          )
        ],
      ),
    );
  }
}

class SearchResultsPage extends StatefulWidget {
  final String searchTerm;
  final SettingsController settingsController;

  SearchResultsPage({
    Key? key,
    required this.searchTerm,
    required this.settingsController,
  }) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Books> searchResults = [];
  List<Books> filteredBooksList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try {
      var Books = await Api.getBook();

      setState(() {
        searchResults = Books;
        filteredBooksList = searchResults
            .where((book) =>
                book.name
                    ?.toLowerCase()
                    .contains(widget.searchTerm.toLowerCase()) ??
                false)
            .toList();
      });
    } catch (e) {
      // Handle kesalahan jika ada
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView(padding: const EdgeInsets.only(top: 10), children: [
        ListView.separated(
          padding: const EdgeInsets.all(20),
          primary: false,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: filteredBooksList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    settingsController: widget.settingsController,
                    books: filteredBooksList[index],
                  ),
                ),
              ),
              child: SizedBox(
                height: 120,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Hero(
                        tag: filteredBooksList[index],
                        child: Image.asset(
                          'assets/images/' +
                              filteredBooksList[index].imgUrl.toString(),
                          fit: BoxFit.cover,
                          width: 90,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredBooksList[index].name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            filteredBooksList[index].desc.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            filteredBooksList[index]
                                .type!
                                .join(", ")
                                .replaceAll(RegExp(r"[\[\]]"), ""),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
