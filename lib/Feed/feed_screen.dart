import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skilla/Feed/feed_bloc.dart';
import 'package:skilla/Post/post_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/components/custom_app_bar.dart';
import 'package:skilla/utils/components/native_dialog.dart';
import 'package:skilla/utils/components/native_loading.dart';
import 'package:skilla/utils/components/post_item.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/firebase_instance.dart';
import 'package:skilla/utils/model/post.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _bloc = FeedBloc();

  @override
  void initState() {
    super.initState();
    _onInit();
    _onSubscribe();
    FirebaseInstance.getFirebaseInstance().setCurrentScreen(
        screenName: kScreenNameFeed,
        screenClassOverride: kScreenClassOverrideFeed);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _onUnsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: CustomAppBar(
          titleImg: 'assets/navlogo.png',
          center: true,
          widgets: [
            _buildFlatButton(),
          ],
        ),
        body: Padding(
          padding: Utils.getPaddingDefault(),
          child: _BuildStreamFeed(
            bloc: _bloc,
          ),
        ),
      ),
    );
  }

  _onInit() {
    _bloc.getUser().then((value) {
      setState(() {
        _bloc.userEmail = value.data.email;
        _bloc.user = value.data;
      });
    });
    _bloc.doRequestGetFeed(true);
  }

  // >>>>>>>>>> EVENTS

  _onSubscribe() {
    EventCenter.getInstance().newPostEvent.subscribe(_refreshFeed);
    EventCenter.getInstance().deletePostEvent.subscribe(_refreshFeedDelete);
    EventCenter.getInstance().scrollEvent.subscribe(_scrollToTheTop);
  }

  _onUnsubscribe() {
    EventCenter.getInstance().newPostEvent.unsubscribe(_refreshFeed);
    EventCenter.getInstance().deletePostEvent.unsubscribe(_refreshFeedDelete);
    EventCenter.getInstance().scrollEvent.unsubscribe(_scrollToTheTop);
  }

  _refreshFeed(NewPostEventArgs args) {
    if (args.isNewPost) {
      _bloc.doRequestGetFeed(false);
    }
  }

  _refreshFeedDelete(DeletePostEventArgs args) {
    if (args.isDeletedPost) {
      _bloc.doRequestGetFeed(false);
    }
  }

  _scrollToTheTop(ScrollEventArgs args) {
    if (args.isScrolling) {
      _bloc.scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  // >>>>>>>>>> WIDGETS

  Widget _buildFlatButton() {
    return FlatButton(
      onPressed: () {
        FirebaseAnalytics()
            .logEvent(name: kNameNavigatePostFeed, parameters: null);
        _doNavigateToPostScreen();
      },
      child: Icon(
        Icons.add_box_outlined,
        color: kSkillaPurple,
      ),
    );
  }

  // >>>>>>>>>> NAVIGATORS

  _doNavigateToPostScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => PostScreen(),
      ),
    );
  }
}

class _BuildStreamFeed extends StatefulWidget {
  final FeedBloc bloc;

  _BuildStreamFeed({this.bloc});

  @override
  __BuildStreamFeedState createState() => __BuildStreamFeedState();
}

class __BuildStreamFeedState extends State<_BuildStreamFeed> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseResponse<List<Post>>>(
      stream: widget.bloc.feedController.stream,
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
                return SmartRefresher(
                  controller: widget.bloc.refreshController,
                  enablePullUp: false,
                  enablePullDown: true,
                  child: _buildListFeed(snapshot),
                  physics: BouncingScrollPhysics(),
                  header: ClassicHeader(
                    refreshingIcon: NativeLoading(animating: true),
                    refreshingText:
                        AppLocalizations.of(context).translate('textLoading'),
                    completeText: AppLocalizations.of(context)
                        .translate('textRefreshCompleted'),
                    idleText: AppLocalizations.of(context)
                        .translate('textPullToRefresh'),
                    releaseText: AppLocalizations.of(context)
                        .translate('textReleaseToRefresh'),
                    completeIcon: Icon(
                      Icons.check,
                      color: Colors.grey,
                    ),
                  ),
                  onRefresh: _onRefresh,
                );
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).translate('textFeedWarning'),
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

  // >>>>>>>>>> WIDGETS

  Widget _buildListFeed(AsyncSnapshot<BaseResponse<List<Post>>> snapshot) {
    return ListView.builder(
      controller: widget.bloc.scrollController,
      itemCount: snapshot.data.data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: PostItem(
            post: snapshot.data.data.elementAt(index),
            user: widget.bloc.user,
          ),
        );
      },
    );
  }

  _onRefresh() async {
    await widget.bloc.refreshFeed();
    widget.bloc.refreshController.refreshCompleted();
  }
}
