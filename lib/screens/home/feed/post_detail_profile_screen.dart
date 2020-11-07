import 'package:flutter/material.dart';
import 'package:skilla/bloc/feed_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/model/post_detail.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class PostDetailProfileScreen extends StatefulWidget {
  final PostDetail post;
  final User user;
  PostDetailProfileScreen({Key key, this.post, this.user}) : super(key: key);
  @override
  _PostDetailProfileScreenState createState() =>
      _PostDetailProfileScreenState();
}

class _PostDetailProfileScreenState extends State<PostDetailProfileScreen> {
  final _feedBloc = FeedBloc();

  @override
  void initState() {
    super.initState();

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
    _feedBloc.dispose();
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
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: kSkillaPurple,
                      ),
                      onPressed: () {
                        _showDialogForDeletePost(context, widget.post);
                      },
                    )
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
                      Icons.favorite,
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
                    onTap: () {},
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
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

  void _showDialogForDeletePost(BuildContext context, PostDetail post) {
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
