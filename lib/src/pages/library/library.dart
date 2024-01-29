import 'package:flutter/material.dart';
import 'package:ebook/src/models/books.dart';
import 'package:ebook/src/pages/detail/detail.dart';
import 'package:ebook/src/settings/settings_controller.dart';
import 'package:ebook/src/api.dart';

class Library extends StatefulWidget {
  const Library({Key? key, required this.settingsController}) : super(key: key);
  final SettingsController settingsController;

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List<Books> mybooksList = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try {
      var myBooks = await Api.getMyBook();

      setState(() {
        mybooksList = myBooks;
      });
    } catch (e) {
      // Handle kesalahan jika ada
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final all_books = mybooksList;
    false;
    return Scaffold(
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            top: 20,
            bottom: 3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "My Reading List",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // const CategoryTitle(title: "My Reading List"),
        ListView.separated(
          padding: const EdgeInsets.all(20),
          primary: false,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: all_books.length,
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
                    books: all_books[index],
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
                        tag: all_books[index],
                        child: Image.asset(
                          'assets/images/' + all_books[index].imgUrl.toString(),
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
                            all_books[index].name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            all_books[index].desc.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            all_books[index]
                                .type!
                                .join(", ")
                                .replaceAll(RegExp(r"[\[\]]"), ""),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // GridTileBar(
                          //     backgroundColor: Colors.white,
                          //     leading: IconButton(
                          //       icon: (booksData.isFavorite)
                          //           ? Icon(Icons.favorite)
                          //           : Icon(Icons.favorite_border_outlined),
                          //       color: Theme.of(context).errorColor,
                          //       onPressed: () {
                          //         booksData.statusFav();
                          //       },
                          //     )),
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
