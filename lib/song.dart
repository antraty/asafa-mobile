// here database request (ORM or else)

import 'dart:convert';
import 'package:asafa/utils.dart';
import 'package:flutter/services.dart';
// import 'package:xml/xml.dart';

class Song {
  int number;
  String title;
  String excerpt;
  List<String> authors;
  String key;
  String lyrics;

  // simple constructor
  Song(
      {required this.number,
      required this.title,
      required this.excerpt,
      required this.authors,
      required this.key,
      required this.lyrics});

  static Map<String, dynamic>? _assetManifest;

  static Future<Map<String, dynamic>> _getAssetManifest() async {
    if (_assetManifest == null) {
      try {
        // Try loading via modern AssetManifest class first (Flutter 3.10+)
        final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
        final list = manifest.listAssets();
        _assetManifest = {for (var key in list) key: true};
      } catch (e) {
        // Fallback for older Flutter versions
        try {
          final manifestContent =
              await rootBundle.loadString('AssetManifest.json');
          _assetManifest = json.decode(manifestContent);
        } catch (err) {
          _assetManifest = {};
        }
      }
    }
    return _assetManifest!;
  }

  Future<List<String>> getSolfaPages() async {
    List<String> pages = [];
    try {
      final manifestMap = await _getAssetManifest();

      final String singlePagePath = 'assets/solfa/$number.png';
      if (manifestMap.containsKey(singlePagePath)) {
        pages.add(singlePagePath);
      } else {
        int pageNum = 1;
        while (true) {
          final String pagePath = 'assets/solfa/${number}_$pageNum.png';
          if (manifestMap.containsKey(pagePath)) {
            pages.add(pagePath);
            pageNum++;
          } else {
            break;
          }
        }
      }
    } catch (e) {
      print("Error loading solfa pages: $e");
    }
    return pages;
  }

  Future<bool> get hasSolfa async {
    List<String> pages = await getSolfaPages();
    return pages.isNotEmpty;
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      number: json['number'],
      title: json['title'],
      excerpt: json['excerpt'],
      authors: List<String>.from(json['authors']),
      key: json['key'],
      lyrics: json['lyrics'],
    );
  }

  // Load song text content
  /* Future<String> getTextContent() async {
    // TODO : load data from database here
    // Load from xml file
    // return await rootBundle.loadString('assets/songs/$number.xml');

    // TODO : use a decoder here if song content is encoded or from database
    // load directly from set lyrics data
    return this.lyrics;
  } */

  String get songDetail {
    // return '$title \n $title \n Do dia $key \n $content';
    return '$title \n $title \n Do dia $key';
  }

  String get authorsStr {
    String authorText = '';
    for (var author in this.authors) {
      if (authorText == '') {
        authorText = '$author';
      } else {
        authorText = '$authorText, $author';
      }
    }
    return authorText;
  }

  String get songBarTitle {
    return '$number - $title';
  }

  /* String excerpt([int length = 30]) {
    // var length = 30;
    if (length < content.length) {
      return content.replaceRange(length, content.length, '...');
    }
    return content;
    // return content.substring(0, 500);
  } */

  // Future<String> loadSongData() async {
  //   return await rootBundle.loadString('assets/json/songs.json');
  // }

  // Future<List> parsedSongData() async {
  //   String jsonString = await loadSongData();
  //   List<dynamic> parsedJson = json.decode(jsonString);
  //   return parsedJson;
  // }

  // Load all songs info
  static Future<List<Song>> getAllSongs() async {
    // TODO : load song from database
    String jsonString = await rootBundle.loadString('assets/json/songs.json');
    List<dynamic> parsedJsonSongs = json.decode(jsonString);

    return parsedJsonSongs.map((jsonSong) {
      return Song.fromJson(jsonSong);
    }).toList();
    // print(parsedJson);
    /* return parsedJson.map((element) {
      return Song.fromJson(
        number: element['number'],
        title: element['title'],
        content: element['excerpt'],
        authors: List<String>.from(element['authors']),
        key: element['key'],
        lyrics: element['lyrics'],
      );
    }).toList(); */
  }

  // Search songs according to textSearch
  static Future<List<Song>> searchSongs(String query) async {
    // Load songs from assets
    String jsonString = await rootBundle.loadString('assets/json/songs.json');
    List<dynamic> parsedJson = json.decode(jsonString);
    // Pattern noSymbolRegExp = RegExp(r'[^\w\s]+');
    // Pattern noSymbolRegExp = RegExp(
    //     r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+', unicode: true);
    // query = query.toLowerCase().replaceAll(noSymbolRegExp, '');
    query = Utils.lowerUnicodeTextext(query);
    // print(query.replaceAll(new RegExp(r'[ôa]'), 'az'));
    // print(query);
    List<dynamic> searchedJson = parsedJson.where((element) {
      if (Utils.lowerUnicodeTextext(element['number'].toString())
          .contains(query)) {
        return true;
      }
      if (Utils.lowerUnicodeTextext(element['title'].toString())
          .contains(query)) {
        return true;
      }
      if (Utils.lowerUnicodeTextext(element['authors'].toString())
          .contains(query)) {
        return true;
      }
      // todo for lyrics: parse xml
      /* String lyrics = XmlDocument.parse(element['lyrics'].toString()).text;
      if (Utils.lowerUnicodeTextext(lyrics).contains(query)) {
        return true;
      } */
      return false;
    }).toList();

    // convert to song list
    return searchedJson.map((jsonSong) {
      return Song.fromJson(jsonSong);
    }).toList();
    /* return searchedJson.map((element) {
      return Song.fromJson(
        number: element['number'],
        title: element['title'],
        content: element['excerpt'],
        authors: List<String>.from(element['authors']),
        key: element['key'],
        lyrics: element['lyrics'],
      );
    }).toList(); */
  }

  // Get song from the json
  static Future<Song?> getSongFromJson(songNumber) async {
    String jsonString = await rootBundle.loadString('assets/json/songs.json');
    List<dynamic> parsedJson = json.decode(jsonString);
    // var nextNumber = 1;
    // if (number + 1 > parsedJson.length)
    var nextSongElement = parsedJson.firstWhere((songElement) {
      // print(songElement);
      if (songElement['number'] == songNumber) return true;
      return false;
    }, orElse: () => null);
    // print(nextSongElement);
    if (nextSongElement != null) {
      Song nextSong = Song.fromJson(nextSongElement);
      /*  Song nextSong = Song.fromJson(
        number: nextSongElement['number'],
        title: nextSongElement['title'],
        content: nextSongElement['excerpt'],
        authors: List<String>.from(nextSongElement['authors']),
        key: nextSongElement['key'],
        lyrics: nextSongElement['lyrics'],
      ); */
      // print(nextSong.title);
      return nextSong;
    } else
      return null;
  }

  Future<Song?> getNextSong() async {
    // int nextNumber = (int.tryParse(number) ?? 1) + 1;
    int nextNumber = number + 1;
    // TODO : replace it with loading song from database
    return await Song.getSongFromJson(nextNumber);
    ;
  }

  Future<Song?> getPreviousSong() async {
    // int prevNumber = (int.tryParse(number) ?? 1) - 1;
    int prevNumber = number - 1;
    return await Song.getSongFromJson(prevNumber);
    ;
  }

  /*List<Song> searchSong(String keyword) async {

  }*/
}
