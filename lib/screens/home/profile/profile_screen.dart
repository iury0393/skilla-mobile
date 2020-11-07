import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:skilla/bloc/profile_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/post_detail.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/feed/post_detail_profile_screen.dart';
import 'package:skilla/screens/home/profile/curriculum_screen.dart';
import 'package:skilla/screens/home/profile/follower_screen.dart';
import 'package:skilla/screens/home/profile/following_screen.dart';
import 'package:skilla/screens/signFlow/sign_in_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

import 'edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _bloc = ProfileBloc();
  PdfController _pdfController;
  String _userId;
  String txtBtnFollow;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _bloc.getUser().then((value) {
      _userId = value.data.id;
      widget.user != null
          ? _bloc.doRequestGetPosts(widget.user.id)
          : _bloc.doRequestGetPosts(_userId);
    });
    _bloc.getUserData();

    widget.user != null
        ? _bloc.isFollowing(widget.user.id).then((value) {
            setState(() {
              _isFollowing = value;
            });
          })
        : print("Usuário próprio");

    widget.user != null ? print(widget.user) : print("Usuário próprio");
    EventCenter.getInstance().editEvent.subscribe(_refreshPage);

    _bloc.followController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          setState(() {
            _isFollowing = true;
            widget.user.followersCount += 1;
          });
          Navigator.pop(context);
          break;
        case Status.LOADING:
          NativeDialog.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Navigator.pop(context);
          NativeDialog.showErrorDialog(context, event.message);
          break;
        default:
          break;
      }
    });

    _bloc.unFollowController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          setState(() {
            _isFollowing = false;
            widget.user.followersCount -= 1;
          });
          Navigator.pop(context);
          break;
        case Status.LOADING:
          NativeDialog.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Navigator.pop(context);
          NativeDialog.showErrorDialog(context, event.message);
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _pdfController.dispose();
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
                      child: _buildFollowButton(widget.user.id),
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
                                      ? '${widget.user.followersCount} ${AppLocalizations.of(context).translate('textProfileFollowers')}'
                                      : '${widget.user.followersCount} ${AppLocalizations.of(context).translate('textProfileFollower')}'
                                  : snapshot.data?.data != 1
                                      ? '${snapshot.data?.data} ${AppLocalizations.of(context).translate('textProfileFollowers')}'
                                      : '${snapshot.data?.data} ${AppLocalizations.of(context).translate('textProfileFollower')}',
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
                        _doNavigateToFollowerScreen(_userId);
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
                                  ? '${widget.user.followingCount} ${AppLocalizations.of(context).translate('textProfileFollowing')}'
                                  : '${snapshot.data?.data} ${AppLocalizations.of(context).translate('textProfileFollowing')}',
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
                        _doNavigateToFollowingScreen(_userId);
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
              widget.user != null
                  ? Text(
                      widget.user.bio != null ? widget.user.bio : "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.paragraph(
                        TextSize.large,
                        weight: FontWeight.w400,
                      ),
                    )
                  : StreamBuilder<BaseResponse<String>>(
                      stream: _bloc.bioController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
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
                        return Container();
                      }),
              widget.user != null
                  ? Text(
                      widget.user.website != null ? widget.user.website : "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.paragraph(
                        TextSize.large,
                        weight: FontWeight.w400,
                      ),
                    )
                  : StreamBuilder<BaseResponse<String>>(
                      stream: _bloc.websiteController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Text(
                            widget.user != null
                                ? widget.user.website != null
                                    ? widget.user.website
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
              StreamBuilder<BaseResponse<List<PostDetail>>>(
                  stream: _bloc.postsController.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        return Center(
                          child: NativeLoading(animating: true),
                        );
                        break;
                      case Status.ERROR:
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          NativeDialog.showErrorDialog(
                              context, snapshot.data.message);
                        });
                        return Container();
                        break;
                      default:
                        if (snapshot.data != null) {
                          if (snapshot.data.data.isNotEmpty) {
                            return Container(
                              width: width,
                              height: height / 5,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.data.length,
                                itemBuilder: (context, index) {
                                  return _buildPostItem(
                                    width,
                                    height,
                                    post: snapshot.data.data,
                                    index: index,
                                  );
                                },
                              ),
                            );
                          } else {
                            return Align(
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('textProfilePostWarning'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.paragraph(
                                  TextSize.xLarge,
                                  weight: FontWeight.w400,
                                  color: kSkillaPurple,
                                ),
                              ),
                            );
                          }
                        }
                        return Container();
                    }
                  }),
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

  GestureDetector _buildPostItem(double width, double height,
      {List<PostDetail> post, int index}) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(
          post.elementAt(index).files[0],
          width: width / 4,
          height: height / 4,
        ),
      ),
      onTap: () {
        _doNavigateToPostDetailScreen(
          widget.user != null ? widget.user : _bloc.user.data,
          post.elementAt(index),
        );
      },
    );
  }

  _doNavigateToPostDetailScreen(User user, PostDetail post) {
    _bloc.doRequestGetPost(post.id).then((value) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => PostDetailProfileScreen(
            user: user,
            post: value,
          ),
        ),
      );
    });
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

  _doNavigateToCurriculumScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CurriculumScreen(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RoundedButton(
      width: 100.0,
      height: 30.0,
      title: AppLocalizations.of(context).translate('textProfileCurriculum'),
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () {
        _doNavigateToCurriculumScreen();
      },
    );
  }

  Widget _buildFollowButton(String id) {
    return RoundedButton(
      width: 100.0,
      height: 30.0,
      title: _isFollowing
          ? txtBtnFollow =
              AppLocalizations.of(context).translate('textProfileFollowing')
          : txtBtnFollow =
              AppLocalizations.of(context).translate('textProfileFollow'),
      titleColor: kSkillaPurple,
      borderColor: kPurpleColor,
      backgroundColor: Colors.white,
      onPressed: () {
        if (_isFollowing) {
          _bloc.doRequestUnfollow(id);
        } else {
          _bloc.doRequestFollow(id);
        }
      },
    );
  }
}
