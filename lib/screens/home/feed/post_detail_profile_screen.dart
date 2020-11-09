import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/feed_bloc.dart';
import 'package:skilla/bloc/likes_bloc.dart';
import 'package:skilla/bloc/post_detail_profile_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/model/comment.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

import 'likes_screen.dart';

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
          Navigator.pop(context);
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
          Navigator.pop(context);
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
          Navigator.pop(context);
          _bloc.textCommentController.clear();
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

    _bloc.deleteCommentController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          refreshFeedWithDeletePost(true);
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

    _feedBloc.deletePostController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          refreshFeedWithDeletePost(true);
          Navigator.pop(context);
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
              Navigator.pop(context);
              feedBloc.doRequestDeletePost(post.id);
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textCancel'),
                style: TextStyles.paragraph(TextSize.xSmall)),
            onPressed: () {
              Navigator.pop(context);
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
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Image.network(
        post.files[0],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
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
      children: [
        IconButton(
          icon: Icon(
            widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: kSkillaPurple,
          ),
          onPressed: () {
            widget.likeBloc.doRequesttoggleLike(widget.post.id);
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
            _doNavigateToLikeScreen(widget.post.user, widget.post);
          },
        ),
        SizedBox(
          width: 20.0,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text(
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
        ),
      ],
    );
  }

  // >>>>>>>>>> NAVIGATORS

  _doNavigateToLikeScreen(User user, Post post) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => LikesScreen(
          user: user,
          post: post,
        ),
      ),
    );
  }
}

class _BuildCaptionPost extends StatelessWidget {
  final Post post;
  final User user;

  _BuildCaptionPost({this.post, this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Container(
            width: 120,
            child: Text(
              user.fullname,
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
          Container(
            width: 180,
            child: Text(
              post.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.paragraph(
                TextSize.medium,
                weight: FontWeight.w400,
              ),
            ),
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

class _BuildComment extends StatelessWidget {
  final List<Comment> commentList;
  final int index;
  final Post post;
  final PostDetailBloc bloc;

  _BuildComment({this.commentList, this.index, this.post, this.bloc});
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
                  commentList.elementAt(index).user.username,
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
                Container(
                  width: 180,
                  child: Text(
                    commentList.elementAt(index).text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.paragraph(
                      TextSize.medium,
                      weight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              if (commentList.elementAt(index).isCommentMine) {
                _showDialogForDeleteComment(
                    context, post, commentList.elementAt(index));
              }
            },
          ),
        ],
      ),
    );
  }

  // >>>>>>>>>> DIALOGS

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
              Navigator.pop(context);
              bloc.doRequestDeleteComment(comments.id, post.id);
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textCancel'),
                style: TextStyles.paragraph(TextSize.xSmall)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
