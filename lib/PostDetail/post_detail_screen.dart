import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:skilla/Feed/feed_bloc.dart';
import 'package:skilla/Like/likes_bloc.dart';
import 'package:skilla/PostDetail/post_detail_bloc.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/components/custom_app_bar.dart';
import 'package:skilla/utils/components/native_dialog.dart';
import 'package:skilla/utils/components/native_loading.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/firebase_instance.dart';
import 'package:skilla/utils/model/comment.dart';
import 'package:skilla/utils/model/post.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

import '../Like/likes_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final User user;
  PostDetailScreen({Key key, this.post, this.user}) : super(key: key);
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostDetailBloc _bloc;
  final _feedBloc = FeedBloc();
  LikeBloc _likeBloc;

  @override
  void initState() {
    super.initState();
    _onInit();
    _doPostDetailStream();
    FirebaseInstance.getFirebaseInstance().setCurrentScreen(
        screenName: kScreenNamePostDetail,
        screenClassOverride: kScreenClassOverridePostDetail);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: Utils.getPaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BuildHeaderPost(
                post: widget.post,
                user: widget.user,
                feedBloc: _feedBloc,
              ),
              _BuildFilePost(
                post: widget.post,
              ),
              _BuildLikeBtn(
                post: widget.post,
                likeBloc: _likeBloc,
              ),
              _BuildCaptionPost(
                post: widget.post,
                user: widget.user,
              ),
              _BuildCommentArea(
                post: widget.post,
                bloc: _bloc,
              ),
              _BuildStreamComments(
                post: widget.post,
                bloc: _bloc,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onInit() {
    _bloc = PostDetailBloc(widget.post.comments);
    _bloc.doGetComment();
    _likeBloc = LikeBloc(widget.user, widget.post);
  }

  // >>>>>>>>>> STREAMS

  _doPostDetailStream() {
    _likeBloc.toggleLikesController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          Get.back();
          setState(() {
            widget.post.isLiked = !widget.post.isLiked;
            if (widget.post.isLiked) {
              widget.post.likesCount += 1;
            } else {
              widget.post.likesCount -= 1;
            }
          });
          break;
        case Status.LOADING:
          NativeDialog.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Get.back();
          NativeDialog.showErrorDialog(context, event.message);
          break;
        default:
          break;
      }
    });

    _bloc.addCommentController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          refreshFeedWithDeletePost(true);
          Get.back();
          _bloc.textCommentController.clear();
          break;
        case Status.LOADING:
          NativeDialog.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Get.back();
          NativeDialog.showErrorDialog(context, event.message);
          break;
        default:
          break;
      }
    });

    _bloc.deleteCommentController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          refreshFeedWithDeletePost(true);
          Get.back();
          break;
        case Status.LOADING:
          NativeDialog.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Get.back();
          NativeDialog.showErrorDialog(context, event.message);
          break;
        default:
          break;
      }
    });

    _feedBloc.deletePostController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          refreshFeedWithDeletePost(true);
          Get.back();
          Get.back();
          break;
        case Status.LOADING:
          NativeDialog.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Get.back();
          NativeDialog.showErrorDialog(context, event.message);
          break;
        default:
          break;
      }
    });
  }

  // >>>>>>>>>> EVENTS

  void refreshFeedWithDeletePost(isDeletePost) {
    EventCenter.getInstance()
        .deletePostEvent
        .broadcast(DeletePostEventArgs(isDeletePost));
  }
}

class _BuildHeaderPost extends StatelessWidget {
  final Post post;
  final User user;
  final FeedBloc feedBloc;

  _BuildHeaderPost({this.user, this.post, this.feedBloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          post.isMine
              ? IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: kSkillaPurple,
                  ),
                  onPressed: () {
                    FirebaseAnalytics()
                        .logEvent(name: kNameDeletePost, parameters: null);
                    _showDialogForDeletePost(context, post);
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  // >>>>>>>>>> DIALOGS

  void _showDialogForDeletePost(BuildContext context, Post post) {
    showNativeDialog(
      context: context,
      builder: (context) => NativeDialog(
        title: AppLocalizations.of(context)
            .translate('textPostDetailDialogTitlePost'),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textDelete'),
                style: TextStyles.paragraph(TextSize.xSmall, color: kRedColor)),
            onPressed: () {
              Get.back();
              feedBloc.doRequestDeletePost(post.id);
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textCancel'),
                style: TextStyles.paragraph(TextSize.xSmall)),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class _BuildFilePost extends StatelessWidget {
  final Post post;

  _BuildFilePost({this.post});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      padding: EdgeInsets.only(bottom: 15.0),
      child: PhotoView(
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        imageProvider: NetworkImage(
          post.files[0],
        ),
      ),
    );
  }
}

class _BuildLikeBtn extends StatefulWidget {
  final Post post;
  final LikeBloc likeBloc;

  _BuildLikeBtn({this.post, this.likeBloc});
  @override
  __BuildLikeBtnState createState() => __BuildLikeBtnState();
}

class __BuildLikeBtnState extends State<_BuildLikeBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                color: kSkillaPurple,
              ),
              onPressed: () {
                FirebaseAnalytics()
                    .logEvent(name: kNameToggleLikePost, parameters: null);
                widget.likeBloc.doRequestToggleLike(widget.post.id);
              },
            ),
            GestureDetector(
              child: Text(
                widget.post.likesCount == 1
                    ? '${widget.post.likesCount} Like'
                    : '${widget.post.likesCount} Likes',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.paragraph(
                  TextSize.large,
                  weight: FontWeight.w400,
                ),
              ),
              onTap: () {
                FirebaseAnalytics()
                    .logEvent(name: kNameNavigateLikePost, parameters: null);
                _doNavigateToLikeScreen(widget.post.user, widget.post);
              },
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
        Text(
          Utils.convertToDisplayTimeDetail(
              widget.post.createdAt.toString(), context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.paragraph(
            TextSize.medium,
            weight: FontWeight.w400,
            color: kSkillaPurple,
          ),
        ),
      ],
    );
  }

  // >>>>>>>>>> NAVIGATORS

  _doNavigateToLikeScreen(User user, Post post) {
    Get.to(
      LikesScreen(
        user: user,
        post: post,
      ),
      transition: Transition.native,
      duration: Duration(milliseconds: 500),
    );
  }
}

class _BuildCaptionPost extends StatefulWidget {
  final Post post;
  final User user;

  _BuildCaptionPost({this.post, this.user});

  @override
  __BuildCaptionPostState createState() => __BuildCaptionPostState();
}

class __BuildCaptionPostState extends State<_BuildCaptionPost> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              widget.user.username,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.paragraph(
                TextSize.large,
                weight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            child: Container(
              width: 180,
              child: Text(
                widget.post.caption,
                maxLines: isClicked ? 5 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.paragraph(
                  TextSize.medium,
                  weight: FontWeight.w400,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                isClicked = !isClicked;
              });
              print(isClicked);
            },
          ),
        ],
      ),
    );
  }
}

class _BuildCommentArea extends StatefulWidget {
  final Post post;
  final PostDetailBloc bloc;

  _BuildCommentArea({this.post, this.bloc});
  @override
  __BuildCommentAreaState createState() => __BuildCommentAreaState();
}

class __BuildCommentAreaState extends State<_BuildCommentArea> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: _buildCommentTextField(),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: kSkillaPurple,
            ),
            onPressed: () {
              FirebaseAnalytics()
                  .logEvent(name: kNameAddComment, parameters: null);
              widget.bloc.doRequestAddComment(widget.post.id);
            },
          ),
        ],
      ),
    );
  }

  // >>>>>>>>>> TEXT FIELD
  Widget _buildCommentTextField() {
    return TextField(
      maxLines: 1,
      textCapitalization: TextCapitalization.none,
      controller: widget.bloc.textCommentController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)
            .translate('textFieldPostDetailCommentHint'),
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}

class _BuildStreamComments extends StatefulWidget {
  final Post post;
  final PostDetailBloc bloc;

  _BuildStreamComments({this.post, this.bloc});
  @override
  __BuildStreamCommentsState createState() => __BuildStreamCommentsState();
}

class __BuildStreamCommentsState extends State<_BuildStreamComments> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseResponse<List<Comment>>>(
      stream: widget.bloc.commentController.stream,
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
                return _buildPostComments(snapshot.data.data);
              }
            }
            return Container();
        }
      },
    );
  }

  Widget _buildPostComments(List<Comment> commentList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ListView.builder(
        itemCount: commentList.length,
        itemBuilder: (context, index) {
          return _BuildComment(
            commentList: commentList,
            index: index,
            post: widget.post,
            bloc: widget.bloc,
          );
        },
      ),
    );
  }
}

class _BuildComment extends StatefulWidget {
  final List<Comment> commentList;
  final int index;
  final Post post;
  final PostDetailBloc bloc;

  _BuildComment({this.commentList, this.index, this.post, this.bloc});

  @override
  __BuildCommentState createState() => __BuildCommentState();
}

class __BuildCommentState extends State<_BuildComment> {
  bool isCommentClicked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[50],
      child: Column(
        children: [
          GestureDetector(
            child: Row(
              children: [
                Text(
                  widget.commentList.elementAt(widget.index).user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.paragraph(
                    TextSize.medium,
                    weight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                GestureDetector(
                  child: Container(
                    width: 180,
                    child: Text(
                      widget.commentList.elementAt(widget.index).text,
                      maxLines: isCommentClicked ? 5 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.paragraph(
                        TextSize.medium,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isCommentClicked = !isCommentClicked;
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              if (widget.commentList.elementAt(widget.index).isCommentMine) {
                FirebaseAnalytics()
                    .logEvent(name: kNameDeleteComment, parameters: null);
                _showDialogForDeleteComment(context, widget.post,
                    widget.commentList.elementAt(widget.index));
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDialogForDeleteComment(
      BuildContext context, Post post, Comment comments) {
    showNativeDialog(
      context: context,
      builder: (context) => NativeDialog(
        title: AppLocalizations.of(context)
            .translate('textPostDetailDialogTitleComment'),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textDelete'),
                style: TextStyles.paragraph(TextSize.xSmall, color: kRedColor)),
            onPressed: () {
              Get.back();
              widget.bloc.doRequestDeleteComment(comments.id, post.id);
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textCancel'),
                style: TextStyles.paragraph(TextSize.xSmall)),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
