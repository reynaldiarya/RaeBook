import 'package:flutter/material.dart';
import 'package:ebook/src/pages/detail/detail.dart';
import 'package:ebook/src/pages/home/widget/category_title.dart';
import 'package:ebook/src/settings/settings_controller.dart';
import 'package:ebook/src/models/books.dart';
import 'package:ebook/src/api.dart';

class BookList extends StatefulWidget {
  BookList({Key? key, required this.settingsController}) : super(key: key);

  final SettingsController settingsController;

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Books> booksList = [];

  @override
  void initState() {
    super.initState();
    // Panggil metode untuk mengambil data dari API saat widget diinisialisasi
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try {
      var Books = await Api.getBook();

      setState(() {
        booksList = Books;
      });
    } catch (e) {
      // Handle kesalahan jika ada
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CategoryTitle(title: "All Books"),
        ListView.separated(
          padding: const EdgeInsets.all(20),
          primary: false,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: booksList.length,
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
                    books: booksList[index],
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
                        tag: booksList[index],
                        child: Image.asset(
                          'assets/images/' + booksList[index].imgUrl.toString(),
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
                            booksList[index].name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            booksList[index].desc.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            booksList[index]
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
      ],
    );
  }
}
