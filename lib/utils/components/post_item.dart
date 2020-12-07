import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skilla/Feed/feed_bloc.dart';
import 'package:skilla/Like/likes_bloc.dart';
import 'package:skilla/Like/likes_screen.dart';
import 'package:skilla/PostDetail/post_detail_screen.dart';
import 'package:skilla/Profile/profile_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/model/post.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

import 'native_dialog.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final User user;
  PostItem({Key key, this.post, this.user}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final _bloc = FeedBloc();
  LikeBloc _likeBloc;

  @override
  void initState() {
    super.initState();
    _bloc.userController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          Get.back();
          _doNavigateToProfileScreen(event.data);
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
    _likeBloc = LikeBloc(widget.user, widget.post);

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

    _bloc.deletePostController.stream.listen((event) {
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
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Row(
                    children: [
                      Utils.loadImage(widget.post.user.avatar, context, true),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        widget.post.user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.paragraph(
                          TextSize.large,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await _bloc.doRequestGetUser(widget.post.user.username);
                  },
                ),
                widget.post.isMine
                    ? IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: kSkillaPurple,
                        ),
                        onPressed: () {
                          _showDialogForUser(context, widget.post);
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
                  widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: kSkillaPurple,
                ),
                onPressed: () {
                  _likeBloc.doRequestToggleLike(widget.post.id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.message_outlined,
                  color: kSkillaPurple,
                ),
                onPressed: () {
                  _doNavigateToPostDetailScreen(widget.post.user, widget.post);
                },
              ),
            ],
          ),
          Row(
            children: [
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
                width: 10.0,
              ),
              GestureDetector(
                child: Text(
                  widget.post.commentsCount == 1
                      ? '${widget.post.commentsCount} ${AppLocalizations.of(context).translate('textPostItemComment')}'
                      : '${widget.post.commentsCount} ${AppLocalizations.of(context).translate('textPostItemComments')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.paragraph(
                    TextSize.large,
                    weight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  _doNavigateToPostDetailScreen(widget.post.user, widget.post);
                },
              ),
              SizedBox(
                width: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Container(
                  width: 100.0,
                  child: Text(
                    Utils.convertToDisplayTimeDetail(
                        widget.post.createdAt.toString(), context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.paragraph(
                      TextSize.medium,
                      weight: FontWeight.w400,
                      color: kSkillaPurple,
                    ),
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
                    widget.post.user.username,
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
        ],
      ),
    );
  }

  void refreshFeedWithDeletePost(isDeletePost) {
    EventCenter.getInstance()
        .deletePostEvent
        .broadcast(DeletePostEventArgs(isDeletePost));
  }

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

  _doNavigateToPostDetailScreen(User user, Post post) {
    _bloc.doRequestGetPost(post.id).then((value) {
      Get.to(
        PostDetailScreen(
          user: user,
          post: value,
        ),
        transition: Transition.native,
        duration: Duration(milliseconds: 500),
      );
    });
  }

  _doNavigateToProfileScreen(User user) {
    Get.to(
      ProfileScreen(
        user: user,
      ),
      transition: Transition.native,
      duration: Duration(milliseconds: 500),
    );
  }

  void _showDialogForUser(BuildContext context, Post post) {
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
              _bloc.doRequestDeletePost(post.id);
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
