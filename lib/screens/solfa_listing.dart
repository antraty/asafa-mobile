import 'package:asafa/components/song_list_tile.dart';
import 'package:asafa/res/values/app_colors.dart';
import 'package:asafa/res/values/app_texts.dart';
import 'package:asafa/screens/song_search.dart';
import 'package:asafa/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SolfaListing extends StatefulWidget {
  final ValueChanged<Song> songSelectedCallback;
  const SolfaListing({Key? key, required this.songSelectedCallback})
      : super(key: key);

  @override
  _SolfaListingState createState() => _SolfaListingState();
}

class _SolfaListingState extends State<SolfaListing> {
  Song? _selectedSongItem;
  ValueChanged<Song>? _songSelectedCallback;

  String sortBy = 'number';
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _songSelectedCallback = widget.songSelectedCallback;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            tooltip: 'Mombamomba',
            icon: Icon(CupertinoIcons.info),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            }),
        title: Text('ASAFA (Solfa)'),
        actions: [
          IconButton(
              tooltip: 'Alahatra',
              icon: Icon(CupertinoIcons.sort_down),
              onPressed: () {
                _pushSort(context);
              }),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            width: double.infinity,
            child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
                        'Hikaroka solfa...',
                        style: TextStyle(
                            color: AppColors.TEXT_GRAY,
                            fontWeight: FontWeight.normal),
                      ),
                      Icon(CupertinoIcons.search)
                    ],
                  )),
                )),
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [Expanded(child: _buildSongsListFuture())],
      )),
    );
  }

  void _pushSearched() {
    showSearch(
        context: context,
        delegate: SearchSong(songs: [], label: AppTexts.SEARCH));
  }

  void _pushSort(context) async {
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
                          title: Text('Lohateny'),
                          value: 'title',
                          groupValue: sortByTemp,
                          onChanged: (String? value) {
                            setState(() => sortByTemp = value ?? 'number');
                          }),
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
        songs.sort((songA, songB) {
          return songA.number - songB.number;
        });
        break;
      case "title":
        songs.sort((songA, songB) {
          return songA.title.compareTo(songB.title);
        });
        break;
    }
  }

  Future<List<Song>> _loadSolfaSongs() async {
    List<Song> allSongs = await Song.getAllSongs();
    List<Song> solfaSongs = [];
    for (var song in allSongs) {
      if (await song.hasSolfa) {
        solfaSongs.add(song);
      }
    }
    return solfaSongs;
  }

  Widget _buildSongsListFuture() {
    return FutureBuilder(
      future: _loadSolfaSongs(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (songs.isEmpty) {
          songs = snapshot.data;
          _sortSongBy(sortBy);
        }

        if (songs.isEmpty) {
          return Center(child: Text("Tsy misy solfa hita"));
        }

        return ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildRow(songs[index]);
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

  Widget _buildRow(Song song) {
    return SongListTile(
        song: song,
        selected: _selectedSongItem == song,
        onTap: () {
          if (_songSelectedCallback != null) {
            _songSelectedCallback!(song);
          }
        });
  }
}
