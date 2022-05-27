import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contants/books.dart';
import '../contants/colors.dart';
import '../controllers/book_controller.dart';
import 'book_list_screen.dart';
import 'bookmark_screen.dart';
import 'search_book_screen.dart';
import 'detail_book_screen.dart';

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

Stack upperBookView(BuildContext context, Book book) {
  return Stack(children: [
    Padding(
        padding: const EdgeInsets.only(top: 72.0),
        child: Container(
          decoration: BoxDecoration(
              color: CustomColor.ebonyClay,
              borderRadius: BorderRadius.circular(20)),
          height: double.infinity,
          width: MediaQuery.of(context).size.width * 0.43,
          // child :const Text('asdasdasd')
        )),
    SizedBox(
        width: MediaQuery.of(context).size.width * 0.43,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    flex: 6,
                    child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image(
                            image: NetworkImage(book.getImage),
                            height: 240.0,
                            width: 100.0,
                            fit: BoxFit.fitHeight)
                        // Stack(
                        //   alignment: Alignment.topLeft,
                        //   children: [

                        //   ],
                        // )
                        )),
                Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(book.getTitle,
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.6,
                              color: CustomColor.text,
                            )))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text('by ${book.getAuthor}',
                            style:
                                mainTextStyle(null, FontWeight.w600, null)))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: ratingIcons(book.getRating),
                        )))
              ],
            )))
  ]);
}

Container lowerBookView(Book book) {
  return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          color: CustomColor.ebonyClay,
          borderRadius: BorderRadius.circular(18)),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Image.network(
                    book.getImage,
                    width: 60,
                    // height: 80,
                    fit: BoxFit.contain,
                  )),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(book.title,
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                              color: CustomColor.text,
                            ))),
                    Row(children: ratingIcons(book.getRating))
                  ]))
            ],
          )));
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _currentIndex = 0;
  BookController? bookController;
  // List<Book> bookList = [];

  @override
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetchBook();
  }

  void _onItemTapped(int idx) {
    switch (idx) {
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
      case 3:
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BookmarkPage()));
          break;
        }
      default:
        break;
    }

    // setState(() {
    //   _currentIndex = idx;
    // });
  }

  void _onBookTapped(Book book) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BookDetailPage(book: book)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Icon(Icons.sort_rounded),
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
      backgroundColor: CustomColor.mirage,
      body: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Consumer<BookController>(
            child: Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(bottom: 18.0),
                          child: CircularProgressIndicator()),
                      Text('Getting Books...',
                          style: mainTextStyle(null, null, null))
                    ])),
            builder: (context, controller, child) => Column(children: [
              Expanded(
                  flex: 7,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Readings',
                            style: mainTextStyle(18, FontWeight.bold, null)),
                        GestureDetector(
                          onTap: () {},
                          child: Text('see all',
                              style: mainTextStyle(
                                  null, null, CustomColor.pitStop)),
                        )
                      ],
                    ),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: bookController!.bookList.isEmpty
                                ? child
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <GestureDetector>[
                                        GestureDetector(
                                          onTap: () => _onBookTapped(
                                              bookController!.bookList[0]),
                                          child: upperBookView(context,
                                              bookController!.bookList[0]),
                                        ),
                                        GestureDetector(
                                          onTap: () => _onBookTapped(
                                              bookController!.bookList[1]),
                                          child: upperBookView(context,
                                              bookController!.bookList[1]),
                                        )
                                      ])))
                  ])),
              Expanded(
                  flex: 6,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Explore',
                                        style: mainTextStyle(
                                            18, FontWeight.bold, null)),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text('see all',
                                          style: mainTextStyle(
                                              null, null, CustomColor.pitStop)),
                                    )
                                  ])),
                          Expanded(
                              child: bookController!.bookList.isEmpty
                                  ? child!
                                  : Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () => _onBookTapped(
                                                  bookController!.bookList[4]),
                                              child: lowerBookView(
                                                  bookController!.bookList[4])),
                                          GestureDetector(
                                              onTap: () => _onBookTapped(
                                                  bookController!.bookList[5]),
                                              child: lowerBookView(
                                                  bookController!.bookList[5])),
                                        ],
                                      )))
                        ],
                      ))),
            ]),
          )),
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
