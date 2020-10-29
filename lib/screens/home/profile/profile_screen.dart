import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/profile_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/profile/follower_screen.dart';
import 'package:skilla/screens/home/profile/following_screen.dart';
import 'package:skilla/screens/signFlow/sign_in_screen.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _bloc = ProfileBloc();

  double _height = 120.0;
  double _width = 120.0;

  @override
  void initState() {
    super.initState();
    _bloc.getUserData();
    widget.user != null ? print(widget.user) : print("Usuário próprio");
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        titleImg: 'assets/navlogo.png',
        center: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Utils.getPaddingDefault(),
          child: Column(
            children: [
              StreamBuilder<BaseResponse<String>>(
                stream: _bloc.avatarController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data.data.isNotEmpty) {
                      if (widget.user != null) {
                        return _loadImage(widget.user.avatar);
                      }
                      return _loadImage(snapshot.data?.data);
                    }
                  } else {
                    return Image.asset(
                      'assets/default_avatar.jpg',
                      width: 80.0,
                      height: 80.0,
                    );
                  }
                  return _buildPlaceholder(context, _height, _width);
                },
              ),
              StreamBuilder<BaseResponse<String>>(
                  stream: _bloc.userNameController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data.data.isNotEmpty) {
                        return Text(
                          widget.user != null
                              ? widget.user.username
                              : snapshot.data?.data,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.paragraph(
                            TextSize.xxLarge,
                            weight: FontWeight.w400,
                          ),
                        );
                      }
                    } else {
                      return Text("");
                    }
                    return Container();
                  }),
              widget.user != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: _buildFollowButton(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.user != null
                            ? Container()
                            : IconButton(
                                icon: Icon(
                                  FeatherIcons.edit,
                                  color: kSkillaPurple,
                                ),
                                onPressed: () {},
                              ),
                        widget.user != null
                            ? Container()
                            : IconButton(
                                icon: Icon(
                                  FeatherIcons.logOut,
                                  color: kSkillaPurple,
                                ),
                                onPressed: () async {
                                  await Utils.cleanDataBase();
                                  _doNavigateToSignInScreen();
                                },
                              ),
                      ],
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<BaseResponse<int>>(
                      stream: _bloc.postCountController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Text(
                            widget.user != null
                                ? widget.user.postCount != 1
                                    ? '${snapshot.data?.data} Posts'
                                    : '${snapshot.data?.data} Post'
                                : snapshot.data?.data != 1
                                    ? '${snapshot.data?.data} Posts'
                                    : '${snapshot.data?.data} Post',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.paragraph(
                              TextSize.medium,
                              weight: FontWeight.w400,
                            ),
                          );
                        }
                        return Container();
                      }),
                  GestureDetector(
                    child: StreamBuilder<BaseResponse<int>>(
                        stream: _bloc.followerCountController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Text(
                              widget.user != null
                                  ? widget.user.followersCount != 1
                                      ? '${widget.user.followersCount} Seguidores'
                                      : '${widget.user.followersCount} Seguidor'
                                  : snapshot.data?.data != 1
                                      ? '${snapshot.data?.data} Seguidores'
                                      : '${snapshot.data?.data} Seguidor',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.paragraph(
                                TextSize.medium,
                                weight: FontWeight.w400,
                              ),
                            );
                          }
                          return Container();
                        }),
                    onTap: () {
                      _doNavigateToFollowerScreen();
                    },
                  ),
                  GestureDetector(
                    child: StreamBuilder<BaseResponse<int>>(
                        stream: _bloc.followingCountController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Text(
                              widget.user != null
                                  ? '${widget.user.followingCount} Seguindo'
                                  : '${snapshot.data?.data} Seguindo',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.paragraph(
                                TextSize.medium,
                                weight: FontWeight.w400,
                              ),
                            );
                          }
                          return Container();
                        }),
                    onTap: () {
                      _doNavigateToFollowingScreen();
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                child: StreamBuilder<BaseResponse<String>>(
                    stream: _bloc.fullNameController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        if (snapshot.data.data.isNotEmpty) {
                          return Text(
                            widget.user != null
                                ? widget.user.fullname
                                : snapshot.data?.data,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.paragraph(
                              TextSize.large,
                              weight: FontWeight.w400,
                            ),
                          );
                        }
                      }
                      return Container();
                    }),
              ),
              StreamBuilder<BaseResponse<String>>(
                  stream: _bloc.bioController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data.data.isNotEmpty) {
                        return Text(
                          widget.user != null
                              ? widget.user.bio != null
                                  ? widget.user.bio
                                  : ""
                              : snapshot.data?.data != null
                                  ? snapshot.data?.data
                                  : "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.paragraph(
                            TextSize.large,
                            weight: FontWeight.w400,
                          ),
                        );
                      }
                    }
                    return Container();
                  }),
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
                  _buildPostItem(width, height),
                  _buildPostItem(width, height),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildPostItem(double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/post.jpg',
        width: width / 4,
        height: height / 4,
      ),
    );
  }

  _doNavigateToSignInScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => SignInScreen()),
        (route) => false);
  }

  _doNavigateToFollowingScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FollowingScreen(),
      ),
    );
  }

  _doNavigateToFollowerScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FollowerScreen(),
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

  Widget _buildFollowButton() {
    return RoundedButton(
      width: 100.0,
      height: 30.0,
      title: 'Seguir',
      titleColor: kSkillaPurple,
      borderColor: kPurpleColor,
      backgroundColor: Colors.white,
      onPressed: () {},
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
}
