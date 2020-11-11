import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skilla/bloc/feed_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/components/post_item.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/feed/post_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
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
  }

  _onUnsubscribe() {
    EventCenter.getInstance().newPostEvent.unsubscribe(_refreshFeed);
    EventCenter.getInstance().deletePostEvent.unsubscribe(_refreshFeedDelete);
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

  // >>>>>>>>>> WIDGETS

  Widget _buildFlatButton() {
    return FlatButton(
      onPressed: () {
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
