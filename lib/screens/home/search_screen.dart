import 'package:flutter/material.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'searchScreen';
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: Utils.getPaddingDefault(),
              child: Column(
                children: [
                  buildRecomendation(),
                  buildRecomendation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildRecomendation() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: GestureDetector(
            child: Row(
              children: [
                Image.asset(
                  'assets/default_avatar.jpg',
                  width: 40.0,
                  height: 40.0,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  'Iury Vasconcelos',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.paragraph(
                    TextSize.large,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
