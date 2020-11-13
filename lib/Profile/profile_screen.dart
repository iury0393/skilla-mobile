import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share/share.dart';
import 'package:skilla/Follower/follower_screen.dart';
import 'package:skilla/Following/following_screen.dart';
import 'package:skilla/PostDetail/post_detail_screen.dart';
import 'package:skilla/Profile/profile_bloc.dart';
import 'package:skilla/SignIn/sign_in_screen.dart';
import 'package:skilla/screens/curriculum_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/components/custom_app_bar.dart';
import 'package:skilla/utils/components/native_dialog.dart';
import 'package:skilla/utils/components/native_loading.dart';
import 'package:skilla/utils/components/rounded_button.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/firebase_instance.dart';
import 'package:skilla/utils/model/post_detail.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/push_notification_manager.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Edit/edit_screen.dart';

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

  final pnm = PushNotificationsManager();

  @override
  void initState() {
    super.initState();
    _onInit();
    _doProfileStream();
    EventCenter.getInstance().editEvent.subscribe(_refreshPage);
    FirebaseInstance.getFirebaseInstance().setCurrentScreen(
        screenName: kScreenNameProfile,
        screenClassOverride: kScreenClassOverrideProfile);
    pnm.init();
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
    return Scaffold(
      appBar: CustomAppBar(
        titleImg: 'assets/navlogo.png',
        center: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Utils.getPaddingDefault(),
          child: widget.user != null
              ? Column(
                  children: [
                    _BuildAvatar(user: widget.user),
                    _BuildUserName(user: widget.user),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: _buildFollowButton(widget.user.id),
                    ),
                    _BuildUserStatus(user: widget.user),
                    _BuildFullName(user: widget.user),
                    _BuildBio(user: widget.user),
                    _BuildWebsite(user: widget.user),
                    _BuildCurriculumBtn(),
                    Divider(
                      height: 20.0,
                      thickness: 2.0,
                    ),
                    _BuildPostInfo(),
                    _BuildStreamPosts(
                      user: widget.user,
                      bloc: _bloc,
                    ),
                  ],
                )
              : StreamBuilder<BaseResponse<User>>(
                  stream: _bloc.profileController.stream,
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
                          return Column(
                            children: [
                              _BuildAvatar(user: snapshot.data.data),
                              _BuildUserName(user: snapshot.data.data),
                              _BuildUserOptions(bloc: _bloc),
                              _BuildUserStatus(user: snapshot.data.data),
                              _BuildFullName(user: snapshot.data.data),
                              _BuildBio(user: snapshot.data.data),
                              _BuildWebsite(user: snapshot.data.data),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _BuildShareBtn(),
                                  _BuildCurriculumBtn(),
                                ],
                              ),
                              Divider(
                                height: 20.0,
                                thickness: 2.0,
                              ),
                              _BuildPostInfo(),
                              _BuildStreamPosts(
                                user: snapshot.data.data,
                                bloc: _bloc,
                              ),
                            ],
                          );
                        }
                        return Container();
                    }
                  },
                ),
        ),
      ),
    );
  }

  _onInit() {
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
  }

  _doProfileStream() {
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

  // >>>>>>>>>> EVENTS

  _refreshPage(EditEventArgs args) {
    if (args.isEdited) {
      _bloc.getUserData();
    }
  }

  // >>>>>>>>>> WIDGET

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
        FirebaseAnalytics().logEvent(name: kNameProfile, parameters: null);
        if (_isFollowing) {
          _bloc.doRequestUnFollow(id);
        } else {
          _bloc.doRequestFollow(id);
        }
      },
    );
  }
}

class _BuildAvatar extends StatelessWidget {
  final User user;

  _BuildAvatar({this.user});
  @override
  Widget build(BuildContext context) {
    return Utils.loadImage(user.avatar, context, false);
  }
}

class _BuildUserName extends StatelessWidget {
  final User user;

  _BuildUserName({this.user});
  @override
  Widget build(BuildContext context) {
    return Text(
      user.username,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.paragraph(
        TextSize.xxLarge,
        weight: FontWeight.w400,
      ),
    );
  }
}

class _BuildUserOptions extends StatelessWidget {
  final ProfileBloc bloc;

  _BuildUserOptions({this.bloc});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            FeatherIcons.edit,
            color: kSkillaPurple,
          ),
          onPressed: () {
            FirebaseAnalytics()
                .logEvent(name: kNameEditProfile, parameters: null);
            _doNavigateToEditScreen(context);
          },
        ),
        IconButton(
          icon: Icon(
            FeatherIcons.logOut,
            color: kSkillaPurple,
          ),
          onPressed: () async {
            FirebaseAnalytics()
                .logEvent(name: kNameLogOutProfile, parameters: null);
            await Utils.cleanDataBase();
            _doNavigateToSignInScreen(context);
          },
        ),
      ],
    );
  }

  _doNavigateToSignInScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => SignInScreen()),
        (route) => false);
  }

  _doNavigateToEditScreen(BuildContext context) async {
    bloc.getUser().then((value) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => EditScreen(
            user: value.data,
          ),
        ),
      );
    });
  }
}

class _BuildUserStatus extends StatelessWidget {
  final User user;

  _BuildUserStatus({this.user});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          user.postCount != 1
              ? '${user.postCount} Posts'
              : '${user.postCount} Post',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.paragraph(
            TextSize.medium,
            weight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          child: Text(
            user.followersCount != 1
                ? '${user.followersCount} ${AppLocalizations.of(context).translate('textProfileFollowers')}'
                : '${user.followersCount} ${AppLocalizations.of(context).translate('textProfileFollower')}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.paragraph(
              TextSize.medium,
              weight: FontWeight.w400,
            ),
          ),
          onTap: () {
            FirebaseAnalytics()
                .logEvent(name: kNameNavigateFollowerProfile, parameters: null);
            _doNavigateToFollowerScreen(context, user.id);
          },
        ),
        GestureDetector(
          child: Text(
            '${user.followingCount} ${AppLocalizations.of(context).translate('textProfileFollowing')}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.paragraph(
              TextSize.medium,
              weight: FontWeight.w400,
            ),
          ),
          onTap: () {
            FirebaseAnalytics().logEvent(
                name: kNameNavigateFollowingProfile, parameters: null);
            _doNavigateToFollowingScreen(context, user.id);
          },
        ),
      ],
    );
  }

  _doNavigateToFollowerScreen(BuildContext context, String id) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FollowerScreen(
          id: id,
        ),
      ),
    );
  }

  _doNavigateToFollowingScreen(BuildContext context, String id) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FollowingScreen(
          id: id,
        ),
      ),
    );
  }
}

class _BuildFullName extends StatelessWidget {
  final User user;

  _BuildFullName({this.user});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
      child: Text(
        user.fullname,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.paragraph(
          TextSize.large,
          weight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _BuildBio extends StatelessWidget {
  final User user;

  _BuildBio({this.user});
  @override
  Widget build(BuildContext context) {
    return Text(
      user.bio != null ? user.bio : "",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.paragraph(
        TextSize.large,
        weight: FontWeight.w400,
      ),
    );
  }
}

class _BuildWebsite extends StatelessWidget {
  final User user;

  _BuildWebsite({this.user});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        user.website != null ? user.website : "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.paragraph(
          TextSize.large,
          weight: FontWeight.w400,
          isLink: true,
          color: kSkillaPurple,
        ),
      ),
      onTap: () {
        if (user.website != null) {
          FirebaseAnalytics()
              .logEvent(name: kNameNavigateWebsiteProfile, parameters: null);
          _launchURL(user.website);
        } else {
          print("Sem website");
        }
      },
    );
  }

  _launchURL(String website) async {
    String url = 'https://$website';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível acessar o site: $url';
    }
  }
}

class _BuildCurriculumBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: _buildCurriculumButton(context),
    );
  }

  Widget _buildCurriculumButton(BuildContext context) {
    return RoundedButton(
      width: 100.0,
      height: 30.0,
      title: AppLocalizations.of(context).translate('textProfileCurriculum'),
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () {
        FirebaseAnalytics()
            .logEvent(name: kNameNavigateCurriculumProfile, parameters: null);
        _doNavigateToCurriculumScreen(context);
      },
    );
  }

  _doNavigateToCurriculumScreen(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CurriculumScreen(),
      ),
    );
  }
}

class _BuildShareBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.share,
        color: kSkillaPurple,
      ),
      onPressed: () {
        FirebaseAnalytics().logEvent(name: kNameShareProfile, parameters: null);
        _onShare(context);
      },
    );
  }

  _onShare(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    Share.share(
        "Faça download do aplicativo Skilla e entre nessa comunidade que não para de crescer.",
        subject: "LINK DE DOWNLOAD",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

class _BuildPostInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _BuildStreamPosts extends StatefulWidget {
  final User user;
  final ProfileBloc bloc;

  _BuildStreamPosts({this.user, this.bloc});
  @override
  __BuildStreamPostsState createState() => __BuildStreamPostsState();
}

class __BuildStreamPostsState extends State<_BuildStreamPosts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseResponse<List<PostDetail>>>(
      stream: widget.bloc.postsController.stream,
      builder: (context, snapshot) {
        switch (snapshot.data?.status) {
          case Status.LOADING:
            return Center(
              child: NativeLoading(animating: true),
            );
            break;
          case Status.ERROR:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NativeDialog.showErrorDialog(context, snapshot.data.message);
            });
            return Container();
            break;
          default:
            if (snapshot.data != null) {
              if (snapshot.data.data.isNotEmpty) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      return _buildPostItem(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height,
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
      },
    );
  }

  Widget _buildPostItem(double width, double height,
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
        FirebaseAnalytics()
            .logEvent(name: kNameNavigatePostDetailProfile, parameters: null);
        _doNavigateToPostDetailScreen(
          widget.user != null ? widget.user : widget.bloc.user.data,
          post.elementAt(index),
        );
      },
    );
  }

  _doNavigateToPostDetailScreen(User user, PostDetail post) {
    widget.bloc.doRequestGetPost(post.id).then((value) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => PostDetailScreen(
            user: user,
            post: value,
          ),
        ),
      );
    });
  }
}
