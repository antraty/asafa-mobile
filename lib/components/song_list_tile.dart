import 'package:asafa/res/values/app_colors.dart';
import 'package:asafa/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SongListTile extends StatelessWidget {
  final Song song;
  final bool? selected;
  final GestureTapCallback? onTap;

  SongListTile({Key? key, required this.song, this.onTap, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 22,
        child: CircleAvatar(
          backgroundColor: AppColors.SECONDARY20,
          // backgroundColor: AppColors.PRIMARY10,
          foregroundColor: AppColors.SECONDARY,
          radius: 22,
          child: Text(
            song.number.toString(),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      title: Text(
        song.title,
        maxLines: 2,
        style: TextStyle(
          height: 1.1,
          // fontSize: 16.0,
          // fontWeight: FontWeight.w700,
          // color: AppColors.TEXT_BLACK,
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(top: 4),
        child: Text(
          // song.excerpt(50),
          song.excerpt,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // style: TextStyle(
          //     // fontSize: 14.0,
          //     // color: AppColors.TEXT_GRAY,
          //     ),
        ),
      ),
      trailing: FutureBuilder<bool>(
        future: song.hasSolfa,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return Icon(Icons.music_note, color: AppColors.PRIMARY, size: 20);
          }
          return SizedBox.shrink();
        },
      ),
      // contentPadding: ,
      selected: selected ?? false,
      onTap: onTap,
    );
  }
}
