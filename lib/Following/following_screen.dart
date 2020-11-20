import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skilla/Following/following_bloc.dart';
import 'package:skilla/Profile/profile_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/components/custom_app_bar.dart';
import 'package:skilla/utils/components/native_dialog.dart';
import 'package:skilla/utils/components/native_loading.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/firebase_instance.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class FollowingScreen extends StatefulWidget {
  final String id;
  const FollowingScreen({Key key, this.id}) : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  FollowingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _onInit();
    FirebaseInstance.getFirebaseInstance().setCurrentScreen(
        screenName: kScreenNameFollowing,
        screenClassOverride: kScreenClassOverrideFollowing);
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
        titleImg: kAppBarImg,
        center: true,
      ),
      body: Padding(
        padding: Utils.getPaddingDefault(),
        child: _BuildStream(
          bloc: _bloc,
        ),
      ),
    );
  }

  _onInit() {
    _bloc = FollowingBloc(widget.id);
    _bloc.getUser().then((value) {
      setState(() {
        _bloc.userEmail = value.data.email;
      });
    });
    _bloc.doRequestGetFollowings();
  }
}

class _BuildStream extends StatefulWidget {
  final FollowingBloc bloc;

  _BuildStream({this.bloc});
  @override
  __BuildStreamState createState() => __BuildStreamState();
}

class __BuildStreamState extends State<_BuildStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseResponse<List<User>>>(
      stream: widget.bloc.followingController.stream,
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
                return _BuildFollowingList(
                  snapshot: snapshot,
                );
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('textFollowingWarning'),
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

class _BuildFollowingList extends StatefulWidget {
  final AsyncSnapshot<BaseResponse<List<User>>> snapshot;

  _BuildFollowingList({this.snapshot});
  @override
  __BuildFollowingListState createState() => __BuildFollowingListState();
}

class __BuildFollowingListState extends State<_BuildFollowingList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data.data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: _BuildFollowingCard(
                user: widget.snapshot.data.data[index],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BuildFollowingCard extends StatelessWidget {
  final User user;

  _BuildFollowingCard({this.user});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseAnalytics()
            .logEvent(name: kNameNavigateProfileFollowing, parameters: null);
        _doNavigateToProfileScreen(context, user);
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

  // >>>>>>>>>> Navigators

  _doNavigateToProfileScreen(BuildContext context, User user) {
    Get.to(
      ProfileScreen(
        user: user,
      ),
      transition: Transition.native,
      duration: Duration(milliseconds: 500),
    );
  }
}
