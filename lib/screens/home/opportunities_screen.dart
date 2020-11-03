import 'package:flutter/material.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class OpportunitiesScreen extends StatefulWidget {
  OpportunitiesScreen({Key key}) : super(key: key);

  @override
  _OpportunitiesScreenState createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Scaffold(
        appBar: CustomAppBar(
          titleImg: 'assets/navlogo.png',
          center: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Utils.getPaddingDefault(),
            child: Column(
              children: [
                buildPost(
                  width,
                  height,
                  'assets/google.jpeg',
                  'Google',
                  'assets/googleDev.png',
                  'Oportunidade para ser um desenvolvedor na Google\nResponda esse comentário para se inscrever.',
                ),
                buildPost(
                  width,
                  height,
                  'assets/ibm.jpeg',
                  'IBM',
                  'assets/ibmDev.png',
                  'Seja um DevOpsSec na IBM!\nResponda esse comentário para se inscrever.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildPost(double width, double height, String authorImg, String author,
      String postImg, String postText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Row(
                  children: [
                    Image.asset(
                      authorImg,
                      width: 40.0,
                      height: 40.0,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      author,
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
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: kSkillaPurple,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 70.0, bottom: 15.0),
          child: Image.asset(
            postImg,
            width: width / 2,
            height: height / 3,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: kSkillaPurple,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: kSkillaPurple,
              ),
              onPressed: () {},
            ),
          ],
        ),
        Text(
          '7 Likes',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.paragraph(
            TextSize.large,
            weight: FontWeight.w400,
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.paragraph(
                  TextSize.medium,
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Container(
                width: 180,
                child: Text(
                  postText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.paragraph(
                    TextSize.medium,
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
          child: Text(
            '3 meses atrás',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.paragraph(
              TextSize.medium,
              weight: FontWeight.w400,
              color: kSkillaPurple,
            ),
          ),
        ),
        TextField(
          maxLines: 8,
          decoration: InputDecoration.collapsed(
            hintText: "Adicione um comentário",
          ),
        ),
      ],
    );
  }
}
