import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'search_book_screen.dart';
import 'book_list_screen.dart';
import 'detail_book_screen.dart';
import '../contants/books.dart';
import '../contants/colors.dart';
import '../controllers/book_controller.dart';

TextStyle mainTextStyle(double? size, FontWeight? weight, Color? color) {
  return TextStyle(
      color: color ?? CustomColor.text,
      fontSize: size ?? 14,
      fontWeight: weight ?? FontWeight.normal,
      fontFamily: 'PlayfairDisplay');
}

List<Icon> ratingIcons(double? rating) {
  double getRating = rating ?? 0.0;
  double counter = getRating;
  List<Icon> ratingList = <Icon>[];
  int restRating = (5.0 - getRating).toInt();
  for (int x = 1; x <= getRating.toInt(); x++, counter--) {
    ratingList.add(const Icon(Icons.star_rounded,
        color: CustomColor.starRating, size: 16));
  }
  if ((counter % 2) > 0.0) {
    ratingList.add(const Icon(Icons.star_half_rounded,
        color: CustomColor.starRating, size: 16));
  }
  if (restRating > 0) {
    for (int x = 1; x <= restRating; x++) {
      ratingList.add(const Icon(Icons.star_border_rounded,
          color: CustomColor.starRating, size: 16));
    }
  }
  return ratingList;
}

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final int _currentIndex = 3;
  BookController? bookController;

  @override
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
  }

  void _onBookTapped(Book book) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BookDetailPage(book: book)));
  }

  void _onItemTapped(int idx) {
    switch (idx) {
      case 0:
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
          break;
        }
      case 1:
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BookSearchPage()));
          break;
        }
      case 2:
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BookListPage()));
          break;
        }
      default:
        break;
    }

    // setState(() {
    //   _currentIndex = idx;
    // });
  }

  // void _onItemTapped(int idx) {
  //   setState(() {
  //     _currentIndex = idx;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.mirage,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          elevation: 0,
          flexibleSpace: Container(color: CustomColor.mirage),
          title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bookmarked Book",
                    style: TextStyle(
                        color: CustomColor.text,
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.w900,
                        fontSize: 20),
                  ),
                  Row(children: [
                    const Icon(Icons.search),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/images/therock.jpg',
                              fit: BoxFit.cover,
                            )))
                  ])
                ],
              ))),
      body: Consumer<BookController>(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 18.0),
                  child: Icon(
                    Icons.bookmarks_outlined,
                    color: CustomColor.pitStop,
                    size: 54,
                  )),
              Text('Bookmark Empty...', style: mainTextStyle(20, null, null))
            ])),
        builder: (context, controller, child) {
          return bookController!.bookmarkedBooks.isEmpty
              ? child!
              : ListView.builder(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  itemCount: bookController!.bookmarkedBooks.length,
                  itemBuilder: ((context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      height: 90,
                      decoration: BoxDecoration(
                          color: CustomColor.ebonyClay,
                          borderRadius: BorderRadius.circular(18)),
                      child: GestureDetector(
                          onTap: (() => _onBookTapped(
                              bookController!.bookmarkedBooks[index])),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(right: 8.0),
                                      child: Image.network(
                                        bookController!
                                            .bookmarkedBooks[index].getImage,
                                        width: 60,
                                        // height: 80,
                                        fit: BoxFit.contain,
                                      )),
                                  Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Text(
                                                bookController!
                                                    .bookmarkedBooks[index]
                                                    .title,
                                                maxLines: 2,
                                                overflow: TextOverflow.clip,
                                                style: const TextStyle(
                                                  fontFamily: 'PlayfairDisplay',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.4,
                                                  color: CustomColor.text,
                                                ))),
                                        Container(
                                            child: Row(
                                                children: ratingIcons(
                                          bookController!
                                              .bookmarkedBooks[index].rating,
                                        )))
                                      ]))
                                ],
                              ))))),
                );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.house), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Books'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Bookmark'),
        ],
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: CustomColor.mirage,
        unselectedItemColor: CustomColor.pitStop,
        selectedItemColor: CustomColor.coolGreen,
        elevation: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
