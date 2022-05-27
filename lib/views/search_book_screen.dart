import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'book_list_screen.dart';
import 'bookmark_screen.dart';
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

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final int _currentIndex = 1;
  BookController? bookController;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  void _onSubmitted(String? string) {
    String getString = string ?? '';
    if (getString != '') {
      bookController!.searchBook(getString);
    }
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
                    // const Text(
                    //   "Bookmarked Book",
                    //   style: TextStyle(
                    //       color: CustomColor.text,
                    //       fontFamily: 'PlayfairDisplay',
                    //       fontWeight: FontWeight.w900,
                    //       fontSize: 20),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width * (75 / 100),
                      height: 55,
                      padding: const EdgeInsets.all(6),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _onSubmitted,
                        textAlign: TextAlign.start,
                        // textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                            fontSize: 18, color: CustomColor.text),
                        decoration: InputDecoration(
                            focusColor: CustomColor.ebonyClay,
                            filled: true,
                            contentPadding: const EdgeInsets.only(
                                left: 18.0, bottom: (55 / 2.5)),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(12.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(12.0)),
                            fillColor: CustomColor.pitStop),
                      ),
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
                  ]))),
      body: Consumer<BookController>(
        builder: (context, controller, child) {
          return bookController!.searchedBook.isEmpty
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: controller.searching
                          ? [
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 18.0),
                                  child: CircularProgressIndicator()),
                              Text('Getting Books...',
                                  style: mainTextStyle(null, null, null))
                            ]
                          : [
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 18.0),
                                  child: Icon(
                                    Icons.search,
                                    color: CustomColor.pitStop,
                                    size: 54,
                                  )),
                              Text('Find out what you seek...',
                                  style: mainTextStyle(20, null, null))
                            ]))
              : ListView.builder(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                  itemCount: bookController!.searchedBook.length,
                  itemBuilder: ((context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      height: 90,
                      decoration: BoxDecoration(
                          color: CustomColor.ebonyClay,
                          borderRadius: BorderRadius.circular(18)),
                      child: GestureDetector(
                          onTap: (() => _onBookTapped(
                              bookController!.searchedBook[index])),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(right: 8.0),
                                      child: Image.network(
                                        bookController!
                                            .searchedBook[index].getImage,
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
                                                    .searchedBook[index].title,
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
                                              .searchedBook[index].rating,
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
