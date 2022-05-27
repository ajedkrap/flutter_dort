import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas_empat/contants/colors.dart';
import 'package:tugas_empat/controllers/book_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../contants/books.dart';

List<Icon> ratingIcons(double? rating) {
  double getRating = rating ?? 0.0;
  double counter = getRating;
  List<Icon> ratingList = <Icon>[];
  int restRating = (5.0 - getRating).toInt();
  for (int x = 1; x <= getRating.toInt(); x++, counter--) {
    ratingList.add(const Icon(Icons.star_rounded,
        color: CustomColor.starRating, size: 20));
  }
  if ((counter % 2) > 0.0) {
    ratingList.add(const Icon(Icons.star_half_rounded,
        color: CustomColor.starRating, size: 20));
  }
  if (restRating > 0) {
    for (int x = 1; x <= restRating; x++) {
      ratingList.add(const Icon(Icons.star_border_rounded,
          color: CustomColor.starRating, size: 20));
    }
  }
  return ratingList;
}

TextStyle mainTextStyle(double? size, FontWeight? weight, Color? color) {
  return TextStyle(
      color: color ?? CustomColor.text,
      fontSize: size ?? 14,
      fontWeight: weight ?? FontWeight.normal,
      fontFamily: 'PlayfairDisplay');
}

Positioned bigCircle(BuildContext context, double fractionPosition, Color color,
    double opacity) {
  double getSize = MediaQuery.of(context).size.width * 2;
  return Positioned(
      top: -(getSize / fractionPosition),
      child: Container(
        width: getSize,
        height: getSize,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getSize),
            color: color.withOpacity(opacity)),
      ));
}

List<Positioned> circleBackground(BuildContext context, Color? color) {
  Color getColor = color ?? CustomColor.vividAuburn;
  return [
    bigCircle(context, 1.15, getColor, 1.0),
    bigCircle(context, 1.25, getColor, 0.7),
    bigCircle(context, 1.375, getColor, 0.5),
    bigCircle(context, 1.5125, getColor, 0.4),
    bigCircle(context, 1.6725, getColor, 0.3)
  ];
}

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: CustomColor.mirage,
      body: Stack(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: circleBackground(context, widget.book.getColor),
          ),
          Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top,
                right: 20.0,
                left: 20.0,
                bottom: 24.0,
              ),
              child: Column(children: [
                SizedBox(
                    height: AppBar().preferredSize.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            )),
                        Consumer<BookController>(
                            builder: ((context, controller, child) {
                          return GestureDetector(
                              onTap: () => controller.setBookMark(widget.book),
                              child: controller.isBookMarked(widget.book)
                                  ? const Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.bookmark_border,
                                      color: Colors.white,
                                    ));
                        }))
                      ],
                    )),
                Expanded(
                    flex: 5,
                    child: Container(
                        alignment: Alignment.topCenter,
                        child: Image.network(
                          widget.book.getImage,
                        ))),
                Expanded(
                    flex: 2,
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 5,
                                child: Text(widget.book.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontFamily: 'PlayfairDisplay',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                      color: CustomColor.text,
                                    ))),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text('by ${widget.book.getAuthor}',
                                        style: const TextStyle(
                                          fontFamily: 'PlayfairDisplay',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: CustomColor.text,
                                        )))),
                            Expanded(
                                flex: 2,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                            Row(
                                                children: ratingIcons(
                                                    widget.book.getRating)),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: Text(
                                                    '${widget.book.getRating}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)))
                                          ])),
                                      Flexible(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 12.0),
                                              child: Icon(Icons.menu_book,
                                                  color:
                                                      CustomColor.starRating),
                                            ),
                                            Text('${widget.book.getPages}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ]))
                                    ])),
                          ],
                        ))),
                Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.only(top: 12.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${widget.book.getDesc}',
                        style: const TextStyle(
                          color: CustomColor.pitStop,
                          fontFamily: 'PlayfairDisplay',
                          height: 1.5,
                          fontSize: 16,
                        ),
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      _launchUrl(Uri.parse(widget.book.getUrl));
                    },
                    child: Container(
                        width: double.infinity,
                        height: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: CustomColor.coolGreen,
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: CustomColor.coolGreen.withAlpha(60),
                                blurRadius: 12.0,
                                spreadRadius: 0.0,
                                offset: const Offset(
                                  0.0,
                                  6.0,
                                ),
                              )
                            ]),
                        child: const Text('Read Now',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))))
              ]))
        ],
      ),
    );
  }
}
