import 'package:flutter/material.dart';

class Book {
  String title;
  String isbn13;
  String price;
  String image;
  String url;
  late String? desc;
  late String? author;
  late String? pages;
  late Color? color;
  late double? rating;

  Book({
    required this.title,
    required this.isbn13,
    required this.price,
    required this.image,
    required this.url,
    this.desc,
    this.author,
    this.pages,
    this.color,
    this.rating,
  });

  String get getTitle => title;
  String get getIsbn => isbn13;
  String get getPrice => price;
  String get getImage => image;
  String get getUrl => url;
  String? get getDesc => desc ?? "";
  String? get getAuthor => author ?? "";
  String? get getPages => pages ?? "";
  Color? get getColor => color ?? const Color(0xFFFFFFFF);
  double? get getRating => rating ?? 0.0;

  set setDesc(String descr) {
    desc = descr;
  }

  set setAuth(String authr) {
    author = authr;
  }

  set setPage(String pagesr) {
    pages = pagesr;
  }

  set setColor(Color colorr) {
    color = colorr;
  }

  set setRating(double ratingr) {
    rating = ratingr;
  }

  // Book.fromJson(Map<String, dynamic> json){
  //   title = json['title'];

  // }
  // Book.fromJson(Map<String, dynamic> )
}
