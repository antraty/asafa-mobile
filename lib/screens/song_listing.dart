// Screen that shows  song list

import 'package:asafa/components/song_list_tile.dart';
import 'package:asafa/res/values/app_colors.dart';
import 'package:asafa/res/values/app_texts.dart';
import 'package:asafa/screens/song_search.dart';
import 'package:asafa/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SongListing extends StatefulWidget {
  final ValueChanged<Song> songSelectedCallback;
  // final Song selectedSongItem;
  /* SongListing({
    required this.songSelectedCallback,
    // this.selectedSongItem,
  }); */
  const SongListing({Key? key, required this.songSelectedCallback})
      : super(key: key);

  @override
  _SongListingState createState() => _SongListingState(
      // callback function when a song is selected is required as argument
      // songSelectedCallback: songSelectedCallback,
      // selectedSongItem: selectedSongItem
      );
}

// class SongListing extends StatelessWidget {
class _SongListingState extends State<SongListing> {
  Song? _selectedSongItem;
  ValueChanged<Song>? _songSelectedCallback;

  /* _SongListingState({
    required this.songSelectedCallback,
    this.selectedSongItem,
  }); */
  _SongListingState();

  String sortBy = 'number';
  List<Song> songs = [];

  @override
  void initState() {
    // songs = Song.getAllSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // set value for _songSelectedCallback
    _songSelectedCallback = widget.songSelectedCallback;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        // scrolledUnderElevation: 10,
        // Hide back button
        automaticallyImplyLeading: false,
        leading: IconButton(
            // About icon
            tooltip: 'Mombamomba',
            icon: Icon(CupertinoIcons.info),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            }),
        title: Text('ASAFA',
            style: TextStyle(
                // fontWeight: FontWeight.w300,
                )),
        actions: [
          // IconButton(
          //     // Search icon
          //     icon: Icon(
          //       CupertinoIcons.book,
          //     ),
          //     onPressed: _pushSearched),

          IconButton(
              // Sort icon
              tooltip: 'Alahatra',
              // icon: Icon(Icons.sort),
              icon: Icon(CupertinoIcons.sort_down),
              onPressed: () {
                _pushSort(context);
              }),
          // IconButton(icon: Icon(Ionicons), onPressed: _pushSaved)
        ],

        // search button
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: double.infinity,
            child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(24)),
                    //     side: BorderSide(color: AppColors.WHITE, width: 1)),
                    elevation: 1,
                    backgroundColor: AppColors.WHITE,
                    foregroundColor: AppColors.PRIMARY,
                  ),
                  onPressed: _pushSearched,
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '123, lohateny, tonony, ...',
                        style: TextStyle(
                            color: AppColors.TEXT_GRAY,
                            fontWeight: FontWeight.normal),
                      ),
                      Icon(
                        CupertinoIcons.search,
                        // color: AppColors.TEXT_BLACK,
                      )
                    ],
                  )),
                )),
          ),
        ),
      ),

      // body: _buildSongsList(),
      body: SafeArea(
          child: Column(
        children: [
          /* Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: double.infinity,
            child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: AppColors.PRIMARY10,
                    onPrimary: AppColors.PRIMARY,
                  ),
                  onPressed: _pushSearched,
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '123, lohateny, tonony, ...',
                        style: TextStyle(
                            color: AppColors.TEXT_GRAY,
                            fontWeight: FontWeight.normal),
                      ),
                      Icon(
                        CupertinoIcons.search,
                        // color: AppColors.TEXT_BLACK,
                      )
                    ],
                  )),
                )),
          ),
           */
          Expanded(child: _buildSongsListFuture())
        ],
      )),
    );
  }

  void _pushSearched() {
    // final List<String> list = List.generate(10, (index) => "text $index");
    final List<Song> songs = [];
    // showSearch(context: context, delegate: SearchSong(list));
    showSearch(
        context: context,
        delegate: SearchSong(songs: songs, label: AppTexts.SEARCH));
    // new search page here (text_field + result)
  }

  void _pushSort(context) async {
    // search filter
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String sortByTemp = sortBy;
          return new AlertDialog(
            title: new Text('Alahatra araka ny'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      RadioListTile(
                          title: Text('Laharana'),
                          value: 'number',
                          groupValue: sortByTemp,
                          onChanged: (String? value) {
                            setState(() => sortByTemp = value ?? 'number');
                          }),
                      RadioListTile(
                          title: Text('Laharana midina'),
                          value: 'number_down',
                          groupValue: sortByTemp,
                          onChanged: (String? value) {
                            setState(() => sortByTemp = value ?? 'number');
                          }),
                      RadioListTile(
                          title: Text('Lohateny'),
                          value: 'title',
                          groupValue: sortByTemp,
                          onChanged: (String? value) {
                            setState(() => sortByTemp = value ?? 'number');
                          }),
                      RadioListTile(
                          title: Text('Lohateny midina'),
                          value: 'title_down',
                          groupValue: sortByTemp,
                          onChanged: (String? value) {
                            setState(() => sortByTemp = value ?? 'number');
                          }),
                      RadioListTile(
                          title: Text('Tononkira'),
                          value: 'content',
                          groupValue: sortByTemp,
                          onChanged: (String? value) {
                            setState(() => sortByTemp = value ?? 'number');
                          })
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text('Aoka ihany')),
              new TextButton(
                  onPressed: () {
                    setState(() {
                      sortBy = sortByTemp;
                      _sortSongBy(sortBy);
                      /*songs.sort( (songA, songB) {
                        return songA.title.compareTo(songB.title);
                      });*/
                      // songs = [];
                    });
                    Navigator.of(context).pop('Accept');
                  },
                  child: new Text('Alahatra'))
            ],
          );
        });
  }

  void _sortSongBy([String sortFilter = "number"]) {
    switch (sortFilter) {
      case "number":
        // sort by number
        songs.sort((songA, songB) {
          return songA.number - songB.number;
          // return songA.number.compareTo(songB.number);
        });
        break;
      case "number_down":
        // sort by number
        songs.sort((songA, songB) {
          return songB.number - songA.number;
          // return -songA.number.compareTo(songB.number);
        });
        break;
      case "title":
        // sort by title
        songs.sort((songA, songB) {
          return songA.title.compareTo(songB.title);
        });
        break;
      case "title_down":
        // sort by title
        songs.sort((songA, songB) {
          return -songA.title.compareTo(songB.title);
        });
        break;
      case "content":
        // sort by title
        songs.sort((songA, songB) {
          return songA.excerpt.compareTo(songB.excerpt);
        });
        break;
      // no default action
      // default:
    }
  }

  Future<String> _loadSongsData() async {
    return await rootBundle.loadString('assets/json/songs.json');
  }

  Widget _buildSongsListFuture() {
    // Create future list view for song list
    // TODO Move load song to song class, perform song filter there
    Future _future = Song.getAllSongs();
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
          // return Text('Loading...');
        }

        // if (songs.length < 0) {
        if (songs.isEmpty) {
          // if not initialized
          songs = snapshot.data;
        }

        // songs = snapshot.data;

        /*List<dynamic> parsedJson = json.decode(snapshot.data);
        // print(parsedJson);
        songs = parsedJson.map((element) {
          return Song.fromJson(
            number: element['number'],
            title: element['title'],
            content: element['excerpt'],
            author: element['author'],
            key: element['key'],
          );
        }).toList();*/

        // sort by title
        /*songs.sort( (songA, songB) {
          return songA.title.compareTo(songB.title);
        });*/

        return ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(), // prevent scroll
            itemBuilder: (context, index) {
              return _buildRow(songs[index]);
            },
            separatorBuilder: (context, index) {
              // return Container(
              //   height: 1,
              //   color: AppColors.PRIMARY,
              // );
              return Divider(
                height: 1,
              );
            },
            itemCount: songs.length);
      },
    );
  }

  Widget _buildRow(Song song) {
    return SongListTile(
        song: song,
        selected: _selectedSongItem == song,
        onTap: () {
          if (_songSelectedCallback != null) {
            print("tap");
            _songSelectedCallback!(song);
          }
          // browse to song screen here
        });
  }
}
