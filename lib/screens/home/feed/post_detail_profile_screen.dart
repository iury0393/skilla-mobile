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
  LikesBloc _likeBloc;

  @override
  void initState() {
    super.initState();
    _bloc = PostDetailBloc(widget.post.comments);
    _bloc.doGetComment();
    _likeBloc = LikesBloc(widget.user, widget.post);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Utils.loadImage(widget.user.avatar, context, true),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          widget.user.fullname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.paragraph(
                            TextSize.large,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    widget.post.isMine
                        ? IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              color: kSkillaPurple,
                            ),
                            onPressed: () {
                              _showDialogForDeletePost(context, widget.post);
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Image.network(
                  widget.post.files[0],
                  width: width,
                  height: height / 3,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      widget.post.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: kSkillaPurple,
                    ),
                    onPressed: () {
                      _likeBloc.doRequesttoggleLike(widget.post.id);
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
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        widget.user.fullname,
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
                        widget.post.caption,
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
              ),
              Padding(
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
                        _bloc.doRequestAddComment(widget.post.id);
                      },
                    ),
                  ],
                ),
              ),
              StreamBuilder<BaseResponse<List<Comment>>>(
                  stream: _bloc.commentController.stream,
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
                            return _buildPostComments(
                                width, snapshot.data.data);
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

  void refreshFeedWithDeletePost(isDeletePost) {
    EventCenter.getInstance()
        .deletePostEvent
        .broadcast(DeletePostEventArgs(isDeletePost));
  }

  TextField _buildCommentTextField() {
    return TextField(
      maxLines: 1,
      textCapitalization: TextCapitalization.none,
      controller: _bloc.textCommentController,
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

  Container _buildPostComments(double width, List<Comment> commentList) {
    return Container(
      width: width,
      height: 200,
      child: ListView.builder(
        itemCount: commentList.length,
        itemBuilder: (context, index) {
          return buildComment(commentList, index);
        },
      ),
    );
  }

  Container buildComment(List<Comment> commentList, int index) {
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
                    context, widget.post, commentList.elementAt(index));
              }
            },
          ),
        ],
      ),
    );
  }

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
              _bloc.doRequestDeleteComment(comments.id, post.id);
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
              _feedBloc.doRequestDeletePost(post.id);
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
