import 'package:asafa/components/song_list_tile.dart';
import 'package:asafa/res/values/app_colors.dart';
import 'package:asafa/res/values/app_texts.dart';
import 'package:asafa/screens/song_detail.dart';
import 'package:asafa/song.dart';
import 'package:flutter/material.dart';

class SearchSong extends SearchDelegate {
  String selectedResult = "";
  // final List<Song> songs;
  List<Song> songs = [];
  List<String> listExample = [];
  String? label = AppTexts.SEARCH;
  // SearchSong(this.listExample);
  // SearchSong();
  SearchSong({required this.songs, this.label})
      : super(searchFieldLabel: label);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
        // icon that clear search content
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container(
      child: Center(
          // child: Text(selectedResult),
          // child: Text(query),
          child: Stack(
        children: [
          // Text(query),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return _buildSongsSearchListFuture(context, query);
          })
        ],
      )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    // List<String> suggestionList = ["suggestion 1", "sugestion 2"];

    // do here suggestion
    // query.isEmpty
    //     ? suggestionList = []
    //     : suggestionList
    //         .addAll(listExample.where((element) => element.contains(query)));

    // TODO: implement buildSuggestions
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              suggestionList[index],
            ),
            onTap: () {
              selectedResult = suggestionList[index];
              showResults(context);
            },
          );
        });
  }

  Widget _buildSongsSearchListFuture(BuildContext context, String query) {
    // Create future list view for song list
    Future _future = Song.searchSongs(query);
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        songs = snapshot.data;
        if (songs.isEmpty) {
          return Center(
              child: Text(
            "Tsy nahitana hira",
            style: TextStyle(fontSize: 16),
          ));
        }

        return ListView.separated(
            itemBuilder: (context, index) {
              return _buildRow(context, songs[index]);
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
              );
            },
            itemCount: songs.length);
      },
    );
  }

  // Widget _buildRow(BuildContext context, StateSetter setState, Song song) {
  Widget _buildRow(BuildContext context, Song song) {
    return SongListTile(
      song: song,
      onTap: () {
        _songSelected(context, song);
      },
    );
  }

  void _songSelected(BuildContext context, Song song) {
    // calback function when song is selected
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // CupertinoPageRoute<void>(
        builder: (BuildContext context) {
          return SongDetails(
            isInTabletLayout: false,
            song: song,
          );
        },
      ),
    );
  }
}
