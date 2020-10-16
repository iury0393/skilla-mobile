import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profileScreen';
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: Utils.getPaddingDefault(),
              child: Column(
                children: [
                  Image.asset(
                    'assets/default_avatar.jpg',
                    width: 80.0,
                    height: 80.0,
                  ),
                  Text(
                    'Iury0393',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.paragraph(
                      TextSize.xxLarge,
                      weight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      FeatherIcons.edit,
                      color: kSkillaPurple,
                    ),
                    onPressed: () {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '1 Post',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.paragraph(
                          TextSize.medium,
                          weight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          '5 Seguidores',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.paragraph(
                            TextSize.medium,
                            weight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: Text(
                          '5 Seguindo',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.paragraph(
                            TextSize.medium,
                            weight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                    child: Text(
                      'Iury Vasconcelos',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.paragraph(
                        TextSize.large,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    'Desenvolvedor Fullstack',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.paragraph(
                      TextSize.large,
                      weight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: _buildSubmitButton(),
                  ),
                  Divider(
                    height: 20.0,
                    thickness: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FeatherIcons.archive,
                        color: kSkillaPurple,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Posts',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.paragraph(
                          TextSize.medium,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/post.jpg',
                          width: width / 4,
                          height: height / 4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/post.jpg',
                          width: width / 4,
                          height: height / 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RoundedButton(
      width: 100.0,
      height: 30.0,
      title: 'Curriculo',
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () {},
    );
  }
}
