import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/screens/home/profile/profile_screen.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key key}) : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  double _height = 40.0;
  double _width = 40.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleImg: 'assets/navlogo.png',
        center: true,
      ),
      body: Padding(
        padding: Utils.getPaddingDefault(),
        child: _buildRecomendation(),
      ),
    );
  }

  Column _buildRecomendation() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: GestureDetector(
            child: GestureDetector(
              onTap: () {
                // _doNavigateToProfileScreen(user);
              },
              child: Row(
                children: [
                  _loadImage(
                      "https://res.cloudinary.com/duujebpq4/image/upload/v1594398275/xdbqyrezccmlu17lhgej.jpg"),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    "Iury Vasconcelos",
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
        ),
      ],
    );
  }

  Widget _loadImage(String url) {
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        placeholder: (context, url) =>
            _buildPlaceholder(context, _height, _width),
        errorWidget: (context, url, error) =>
            _buildPlaceholder(context, _height, _width),
        imageUrl: url,
        height: _height,
        width: _width,
        fit: BoxFit.cover,
        imageBuilder: (context, imgProvider) {
          return _buildImageFromURL(imgProvider);
        },
      );
    }

    return _buildPlaceholder(context, _height, _width);
  }

  ClipRRect _buildPlaceholder(
      BuildContext context, double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  ClipRRect _buildImageFromURL(ImageProvider imgProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imgProvider,
          ),
        ),
      ),
    );
  }

  _doNavigateToProfileScreen(User user) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProfileScreen(
          user: user,
        ),
      ),
    );
  }
}
