import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/post_detail_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/model/comment.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/feed/likes_screen.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final User user;
  PostDetailScreen({Key key, this.post, this.user}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _bloc = PostDetailBloc();
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    _bloc.doRequestGetComments(widget.post.user.id);
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
      body: Padding(
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
                  widget.post.isMine
                      ? IconButton(
                          icon: Icon(
                            Icons.more_horiz,
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
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    widget.post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: kSkillaPurple,
                  ),
                  onPressed: () {},
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
              padding: EdgeInsets.only(top: 20.0),
              child: TextField(
                maxLines: 2,
                decoration: InputDecoration.collapsed(
                  hintText: "Adicione um comentário",
                ),
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
                          return _buildPostComments(width, snapshot);
                        }
                      }
                      return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Container _buildPostComments(
      double width, AsyncSnapshot<BaseResponse<List<Comment>>> snapshot) {
    return Container(
      width: width,
      height: 200,
      child: ListView.builder(
        itemCount: snapshot.data.data.length,
        itemBuilder: (context, index) {
          return buildComment(snapshot.data.data, index);
        },
      ),
    );
  }

  Container buildComment(List<Comment> comments, int index) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[50],
      child: Column(
        children: [
          GestureDetector(
            child: Row(
              children: [
                Text(
                  comments.elementAt(index).user.username,
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
                    comments.elementAt(index).text,
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
              if (comments.elementAt(index).isCommentMine) {
                print("TRUE");
              } else {
                print("FALSE");
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
}
