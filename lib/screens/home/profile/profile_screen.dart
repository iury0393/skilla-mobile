import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/profile_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/profile/following_screen.dart';
import 'package:skilla/screens/home/profile/follower_screen.dart';
import 'package:skilla/screens/signFlow/sign_in_screen.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

import 'edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final String id;
  ProfileScreen({Key key, this.user, this.id}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _bloc = ProfileBloc();
  String id;

  @override
  void initState() {
    super.initState();
    _bloc.getUser().then((value) {
      setState(() {
        _bloc.userEmail = value.data.email;
        id = value.data.id;
      });
    });
    _bloc.getUserData();
    widget.user != null ? print(widget.user) : print("Usuário próprio");
    EventCenter.getInstance().editEvent.subscribe(_refreshPage);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    EventCenter.getInstance().editEvent.unsubscribe(_refreshPage);
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
                        return Utils.loadImage(
                            widget.user.avatar, context, false);
                      }
                      return Utils.loadImage(
                          snapshot.data?.data, context, false);
                    }
                  } else {
                    return Image.asset(
                      'assets/default_avatar.jpg',
                      width: 80.0,
                      height: 80.0,
                    );
                  }
                  return Container();
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
                        IconButton(
                          icon: Icon(
                            FeatherIcons.edit,
                            color: kSkillaPurple,
                          ),
                          onPressed: () {
                            _doNavigateToEditScreen();
                          },
                        ),
                        IconButton(
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
                                    ? '${widget.user.postCount} Posts'
                                    : '${widget.user.postCount} Post'
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
                      if (widget.user != null) {
                        _doNavigateToFollowerScreen(widget.user.id);
                      } else {
                        _doNavigateToFollowerScreen(_bloc.id);
                      }
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
                      if (widget.user != null) {
                        _doNavigateToFollowingScreen(widget.user.id);
                      } else {
                        _doNavigateToFollowingScreen(_bloc.id);
                      }
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

  _refreshPage(EditEventArgs args) {
    if (args.isEdited) {
      _bloc.getUserData();
    }
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

  _doNavigateToEditScreen() async {
    await UserDAO().get().then((value) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => EditScreen(
            user: value.data,
          ),
        ),
      );
    });
  }

  _doNavigateToFollowingScreen(String id) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FollowingScreen(
          id: id,
        ),
      ),
    );
  }

  _doNavigateToFollowerScreen(String id) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FollowerScreen(
          id: id,
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

  Widget _buildFollowButton() {
    return RoundedButton(
      width: 100.0,
      height: 30.0,
      title:
          widget.user.followers.toString().contains(id) ? 'Seguir' : 'Seguindo',
      titleColor: kSkillaPurple,
      borderColor: kPurpleColor,
      backgroundColor: Colors.white,
      onPressed: () {
        if (widget.user.followers.toString().contains(id)) {
          print("Seguir");
        }
        print("Seguindo");
      },
    );
  }
}
