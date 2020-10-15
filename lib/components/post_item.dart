import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';

class PostItem extends StatefulWidget {
  PostItem({Key key}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
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
                IconButton(
                  icon: Icon(
                    FeatherIcons.moreHorizontal,
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
              'assets/post.jpg',
              width: width / 2,
              height: height / 3,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  FeatherIcons.heart,
                  color: kSkillaPurple,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  FeatherIcons.messageSquare,
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
                  'Iury Vasconcelos',
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
                    'Flutter vindo com tudo',
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
          buildComment(),
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
      ),
    );
  }

  Container buildComment() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[50],
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'iury0393',
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
                  'Massa',
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
        ],
      ),
    );
  }
}
