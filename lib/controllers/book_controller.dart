import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import 'dart:convert';

import '../contants/colors.dart';
import '../contants/books.dart';

const String _baseUrl = 'https://api.itbook.store/1.0/';

String getAllNewBookUrl = '${_baseUrl}new';
String getBookDetailUrl = '${_baseUrl}books';
String searchBookUrl = '${_baseUrl}search';

class BookController extends ChangeNotifier {
  List<Book> bookList = [];
  fetchBook() async {
    List bookMap;
    Map<String, dynamic>? responseApi;

    try {
      var url = Uri.parse(getAllNewBookUrl);
      var response = await http.get(url);
      if (response.statusCode > 400) {
        throw Exception('Get Books Error');
      } else {
        responseApi = jsonDecode(response.body);
        bookMap = responseApi?['books'];
        int length = int.parse(responseApi?['total']);

        for (int x = 0; x < length; x++) {
          Map book = bookMap[x];
          dynamic detailBook = await fetchSingleBook(book['isbn13']);
          Color getBookPalette = await _updatePalettes(book['image']);
          Book newBook = Book(
            title: book['title'],
            isbn13: book['isbn13'],
            price: book['price'],
            image: book['image'],
            url: book['url'],
          );
          newBook.setAuth = detailBook['authors'];
          newBook.setColor = getBookPalette;
          newBook.setPage = detailBook['pages'];
          newBook.setDesc = detailBook['desc'];
          newBook.setRating = double.parse(detailBook['rating']);

          bookList.add(newBook);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    // print('Response Status >>> ${response.statusCode}');
    // print('Response Books type >>> ${response.body}');
  }

  Future<Map> fetchSingleBook(String isbn) async {
    dynamic bookDetail;

    try {
      var url = Uri.parse('$getBookDetailUrl/$isbn');
      var response = await http.get(url);
      if (response.statusCode > 400) {
        throw Exception('Get Books Detail Error');
      } else {
        bookDetail = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return bookDetail;
  }

  _updatePalettes(String url) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(url),
        size: const Size(200, 100));

    return generator.dominantColor != null
        ? generator.dominantColor?.color
        : CustomColor.vividAuburn;
  }

  bool searching = false;
  List<Book> searchedBook = [];
  searchBook(String keyword) async {
    searching = true;
    searchedBook = [];
    notifyListeners();

    List bookMap;
    Map<String, dynamic>? responseApi;

    try {
      var url = Uri.parse('$searchBookUrl/$keyword');
      var response = await http.get(url);
      if (response.statusCode > 400) {
        throw Exception('Get Books Error');
      } else {
        responseApi = jsonDecode(response.body);
        bookMap = responseApi?['books'];
        int length = int.parse(responseApi?['total']);

        for (int x = 0; x < length; x++) {
          Map book = bookMap[x];
          dynamic detailBook = await fetchSingleBook(book['isbn13']);
          Color getBookPalette = await _updatePalettes(book['image']);
          Book newBook = Book(
            title: book['title'],
            isbn13: book['isbn13'],
            price: book['price'],
            image: book['image'],
            url: book['url'],
          );
          newBook.setAuth = detailBook['authors'];
          newBook.setColor = getBookPalette;
          newBook.setPage = detailBook['pages'];
          newBook.setDesc = detailBook['desc'];
          newBook.setRating = double.parse(detailBook['rating']);

          searchedBook.add(newBook);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      searching = false;
    }
    notifyListeners();
    // print('Response Status >>> ${response.statusCode}');
    // print('Response Books type >>> ${response.body}');
  }

  List<Book> bookmarkedBooks = [];
  setBookMark(Book book) {
    final bookmarkedIdx =
        bookmarkedBooks.indexWhere((b) => book.isbn13 == b.isbn13);
    if (bookmarkedIdx >= 0) {
      bookmarkedBooks.removeAt(bookmarkedIdx);
    } else {
      bookmarkedBooks.add(book);
    }
    notifyListeners();
  }

  bool isBookMarked(Book book) =>
      (bookmarkedBooks.indexWhere((b) => book.isbn13 == b.isbn13)) >= 0;
}
