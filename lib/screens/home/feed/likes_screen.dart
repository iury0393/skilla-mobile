import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/likes_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/profile/profile_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/firebase_instance.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class LikesScreen extends StatefulWidget {
  final User user;
  final Post post;
  const LikesScreen({Key key, this.user, this.post}) : super(key: key);

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  LikeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LikeBloc(widget.user, widget.post);
    _bloc.doRequestGetLikes();
    FirebaseInstance.getFirebaseInstance().setCurrentScreen(
        screenName: "signIn", screenClassOverride: "SignInPage");
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleImg: 'assets/navlogo.png',
        center: true,
      ),
      body: Padding(
        padding: Utils.getPaddingDefault(),
        child: _StreamBuilderLikes(
          bloc: _bloc,
        ),
      ),
    );
  }
}

class _StreamBuilderLikes extends StatefulWidget {
  final LikeBloc bloc;

  _StreamBuilderLikes({this.bloc});
  @override
  __StreamBuilderLikesState createState() => __StreamBuilderLikesState();
}

class __StreamBuilderLikesState extends State<_StreamBuilderLikes> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseResponse<List<User>>>(
      stream: widget.bloc.likesController.stream,
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
                return _BuildListLikes(
                  snapshot: snapshot,
                );
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).translate('textLikesWarning'),
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
        }
        return Container();
      },
    );
  }
}

class _BuildListLikes extends StatefulWidget {
  final AsyncSnapshot<BaseResponse<List<User>>> snapshot;

  _BuildListLikes({this.snapshot});
  @override
  __BuildListLikesState createState() => __BuildListLikesState();
}

class __BuildListLikesState extends State<_BuildListLikes> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data.data.length,
      itemBuilder: (context, index) {
        return _buildRecommendation(user: widget.snapshot.data.data[index]);
      },
    );
  }

  // >>>>>>>>>> WIDGETS

  Widget _buildRecommendation({User user}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: _buildLikesList(user),
        ),
      ],
    );
  }

  Widget _buildLikesList(User user) {
    return GestureDetector(
      onTap: () {
        _doNavigateToProfileScreen(user);
      },
      child: Row(
        children: [
          Utils.loadImage(user.avatar, context, true),
          SizedBox(
            width: 15.0,
          ),
          Text(
            user.fullname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.paragraph(
              TextSize.large,
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // >>>>>>>>>> NAVIGATORS

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
