import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/feed_bloc.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/feed/likes_screen.dart';
import 'package:skilla/screens/home/feed/post_detail_screen.dart';
import 'package:skilla/screens/home/profile/profile_screen.dart';
import 'package:skilla/utils/constants.dart';
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

  @override
  void initState() {
    super.initState();
    _bloc.userController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          Navigator.pop(context);
          _doNavigateToProfileScreen(event.data);
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
                        widget.post.user.fullname,
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
                widget.user.id == widget.post.user.id
                    ? IconButton(
                        icon: Icon(
                          FeatherIcons.moreHorizontal,
                          color: kSkillaPurple,
                        ),
                        onPressed: () {},
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
          IconButton(
            icon: Icon(
              FeatherIcons.heart,
              color: kSkillaPurple,
            ),
            onPressed: () {},
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
                      ? '${widget.post.commentsCount} Comentário'
                      : '${widget.post.commentsCount} Comentários',
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
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  widget.post.user.fullname,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.paragraph(
                    TextSize.large,
                    weight: FontWeight.w700,
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
            padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
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

  _doNavigateToPostDetailScreen(User user, Post post) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => PostDetailScreen(
          user: user,
          post: post,
        ),
      ),
    );
  }

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
