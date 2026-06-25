import 'package:html/dom.dart' as dom;

/// Song detail screen

// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:asafa/res/values/app_colors.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:asafa/song.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongDetails extends StatefulWidget {
  final bool isInTabletLayout;
  final Song song;

  SongDetails({required this.isInTabletLayout, required this.song});

  @override
  _SongDetailsState createState() =>
      _SongDetailsState(isInTabletLayout: isInTabletLayout, song: song);
}
// class SongDetails extends StatelessWidget {

class _SongDetailsState extends State<SongDetails> {
  final bool isInTabletLayout;

  // final Song song;
  Song song;
  bool isPrevBtnVisible = true;
  // final String textSize = 'normal';
  String textSize = 'normal';
  List<String> solfaPages = [];
  bool isLoadingSolfa = true;
  int _currentSolfaPage = 0;
  final PageController _solfaPageController = PageController();

  // to tell the ui that song lenght (scroll) content differs for different state
  final _scaffolgKey = new GlobalKey<ScaffoldState>();
  // shared preferences for key value storage
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  _SongDetailsState({required this.isInTabletLayout, required this.song});

  @override
  void initState() {
    super.initState();
    _getPrefData();
    _loadSolfa();
  }

  @override
  void dispose() {
    _solfaPageController.dispose();
    super.dispose();
  }

  Future<void> _loadSolfa() async {
    final pages = await song.getSolfaPages();
    if (mounted) {
      setState(() {
        solfaPages = pages;
        isLoadingSolfa = false;
        _currentSolfaPage = 0;
      });
      if (_solfaPageController.hasClients) {
        _solfaPageController.jumpToPage(0);
      }
    }
  }

  Future<Null> _getPrefData() async {
    final SharedPreferences prefs = await sharedPrefs;
    String data = prefs.getString('textSize') ?? 'normal';
    this.setState(() {
      textSize = data;
      print(textSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (song != null) {
      Widget body = Stack(
        children: <Widget>[_buildSongContent(), _btnPrevious(), _btnNext()],
      );

      if (!isLoadingSolfa && solfaPages.isNotEmpty) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            key: _scaffolgKey,
            appBar: AppBar(
              title: Text(song.songBarTitle),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.format_size),
                    onPressed: () {
                      _pushTextSize(context);
                    })
              ],
              bottom: TabBar(
                labelColor: AppColors.PRIMARY,
                unselectedLabelColor: AppColors.TEXT_GRAY,
                tabs: [
                  Tab(text: "Tononkira"),
                  Tab(text: "Solfa"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                body,
                _buildSolfaContent(),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          key: _scaffolgKey,
          appBar: AppBar(
            title: Text(song.songBarTitle),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.format_size),
                  onPressed: () {
                    _pushTextSize(context);
                  })
            ],
          ),
          body: body,
        );
      }
    } else {
      return Text('No song loaded');
    }
  }

  Widget _buildSolfaContent() {
    if (solfaPages.length == 1) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(child: Image.asset(solfaPages[0])),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _solfaPageController,
              itemCount: solfaPages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentSolfaPage = page;
                });
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(child: Image.asset(solfaPages[index])),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: _currentSolfaPage > 0
                      ? () {
                          _solfaPageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
                Text(
                  'Pejy ${_currentSolfaPage + 1} / ${solfaPages.length}',
                  style: TextStyle(
                    color: AppColors.TEXT_GRAY,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: _currentSolfaPage < solfaPages.length - 1
                      ? () {
                          _solfaPageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  void _pushTextSize(context) async {
    // search filter
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String textSizeTemp = textSize;
          return new AlertDialog(
            title: new Text('Habean\'ny soratra'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      RadioListTile(
                          title: Text('Antonony'),
                          value: 'normal',
                          groupValue: textSizeTemp,
                          onChanged: (String? value) {
                            setState(() => textSizeTemp = value ?? 'normal');
                          }),
                      RadioListTile(
                          title: Text('Lehibe'),
                          value: 'large',
                          groupValue: textSizeTemp,
                          onChanged: (String? value) {
                            setState(() => textSizeTemp = value ?? 'normal');
                          }),
                      RadioListTile(
                          title: Text('Tena lehibe'),
                          value: 'xlarge',
                          groupValue: textSizeTemp,
                          onChanged: (String? value) {
                            setState(() => textSizeTemp = value ?? 'normal');
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
                  onPressed: () async {
                    final SharedPreferences prefs = await sharedPrefs;
                    setState(() {
                      textSize = textSizeTemp;
                      prefs.setString('textSize', textSize);
                    });

                    Navigator.of(context).pop('Accept');
                  },
                  child: new Text('Ovaina'))
            ],
          );
        });
  }

  Widget _btnPrevious() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: FutureBuilder(
        future: song.getPreviousSong(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(width: 0, height: 0);
          }
          return Transform.translate(
            offset: Offset(16.0, -16.0),
            child: FloatingActionButton(
              backgroundColor: AppColors.BTN_WHITE,
              foregroundColor: AppColors.TEXT_ACCENT,
              elevation: 4,
              heroTag: null,
              mini: true,
              tooltip: 'Aloha',
              child: Icon(Icons.chevron_left),
              onPressed: () async {
                // Song prevSong = await song.getPreviousSong();
                Song? prevSong = snapshot.data;
                if (prevSong != null) {
                  setState(() {
                    song = prevSong;
                    isLoadingSolfa = true;
                  });
                  _loadSolfa();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _btnNext() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FutureBuilder(
        future: song.getNextSong(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(width: 0, height: 0);
          }
          return Transform.translate(
            offset: Offset(-16.0, -16.0),
            child: FloatingActionButton(
              backgroundColor: AppColors.BTN_WHITE,
              foregroundColor: AppColors.TEXT_ACCENT,
              elevation: 4,
              heroTag: null,
              mini: true,
              tooltip: 'Aloha',
              child: Icon(Icons.chevron_right),
              onPressed: () async {
                // Song nextSong = await song.getNextSong();
                Song? nextSong = snapshot.data;
                if (nextSong != null) {
                  setState(() {
                    song = nextSong;
                    isLoadingSolfa = true;
                  });
                  _loadSolfa();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongContent() {
    return ListView(
      // return Stack(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 72.0),
      children: <Widget>[
        Container(
          // Title
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          margin: EdgeInsets.only(top: 32.0),
          child: Text(
            song.title,
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: _textSizeAdjusted(textSize) * 1.25, // 20 by default
              height: 1.4, // 20 by default
              color: AppColors.PRIMARY,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          // Key
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          margin: EdgeInsets.only(top: 16.0),
          child: Text(
            song.key,
            // 'Do dia D',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: _textSizeAdjusted(textSize),
              color: AppColors.TEXT_GRAY,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            margin: EdgeInsets.only(top: 16.0),
            child: _buildLyricContent(song.lyrics)),
        /* FutureBuilder(
          // Lyric content
          // future: _songFuture,
          future: song.getTextContent(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              // return Text('Loading...');
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            String contentBase64 =
                base64Encode(const Utf8Encoder().convert(snapshot.data));
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                margin: EdgeInsets.only(top: 16.0),
                child: _buildLyricContent(snapshot.data));
          },
        ), */
        Container(
          // Author
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          margin: EdgeInsets.only(top: 24.0),
          child: Text(
            song.authorsStr, // 'Mahefaniriana RAKOTOMALALA',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: _textSizeAdjusted(textSize),
              color: AppColors.TEXT_GRAY,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildLyricContent(htmlText) {
    // build lyric content
    return HtmlWidget(
      htmlText,
      rebuildTriggers: new RebuildTriggers([textSize]),

      // render a custom widget
      customWidgetBuilder: (element) {
        if (element.localName == 'properties') {
          // hide properties tag
          return SizedBox(width: 0, height: 0);
        }
        if (element.classes.contains('chorus')) {
          return Container(
            margin: EdgeInsets.only(left: 24.0, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
                  child: Text(
                    "Isan'andininy :",
                    style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: _textSizeAdjusted(textSize),
                        color: AppColors.TEXT_BLACK,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline),
                  ),
                ),
                HtmlWidget(element.innerHtml,
                    rebuildTriggers: new RebuildTriggers([textSize]),
                    customStylesBuilder: (childElement) {
                  Map<String, String> style = {};

                  style = _linesStyle(childElement, style, textSize);
                  return style;
                })
              ],
            ),
          );
        }
        return null;
      },

      customStylesBuilder: (element) {
        // CSS Styles of an element
        Map<String, String> style = {};

        if (element.localName == 'properties') {
          // hide properties tag
          style['display'] = 'none';
          style['margin'] = '0px';
          style['padding'] = '0px';
          return style;
        }

        if (element.localName == 'verse' || element.classes.contains('verse')) {
          style['display'] = 'block';
          style['margin-bottom'] = '16px';
          style['color'] = AppColors.TEXT_BLACK_CSS;
        }
        if (element.localName == 'chorus' ||
            element.classes.contains('chorus')) {
          style['font-style'] = 'normal';
          style['margin-left'] = '24px';
        }
        style = _linesStyle(element, style, textSize);
        return style;
      },
    );
  }

  Map<String, String> _linesStyle(
      dom.Element element, Map<String, String> style, String textSize) {
    if (element.localName == 'line' ||
        element.localName == 'lines' ||
        element.localName == 'p') {
      style['font-family'] = 'Times New Roman';
      style['line-height'] = '1.8';
      style['display'] = 'block';
      style['color'] = AppColors.TEXT_BLACK_CSS;
      // text size
      style['font-size'] = AppSize.TEXT_SIZE_NORMAL.toString() + 'px';
      if (textSize == 'large') {
        style['font-size'] = AppSize.TEXT_SIZE_LARGE.toString() + 'px';
      } else if (textSize == 'xlarge') {
        style['font-size'] = AppSize.TEXT_SIZE_XLARGE.toString() + 'px';
      }
    }
    return style;
  }

  double _textSizeAdjusted(String textSize) {
    double textSizeDpi = 16;
    if (textSize == 'normal') {
      textSizeDpi = AppSize.TEXT_SIZE_NORMAL;
    }
    if (textSize == 'large') {
      textSizeDpi = AppSize.TEXT_SIZE_LARGE;
    }
    if (textSize == 'xlarge') {
      textSizeDpi = AppSize.TEXT_SIZE_XLARGE;
    }
    return textSizeDpi;
  }
}
