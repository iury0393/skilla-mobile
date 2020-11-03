import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/feed_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/components/post_item.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/utils/constants.dart';
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
    _bloc.getUser().then((value) {
      setState(() {
        _bloc.userEmail = value.data.email;
        _bloc.user = value.data;
      });
    });
    _bloc.doRequestGetFeed();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: CustomAppBar(
          titleImg: 'assets/navlogo.png',
          center: true,
          widgets: [
            FlatButton(
              onPressed: () {},
              child: Icon(
                FeatherIcons.plusSquare,
                color: kSkillaPurple,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: Utils.getPaddingDefault(),
          child: StreamBuilder<BaseResponse<List<Post>>>(
            stream: _bloc.feedController.stream,
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
                      return _buildListFeed(snapshot);
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          'O feed está vazio, siga alguém',
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
          ),
        ),
      ),
    );
  }

  ListView _buildListFeed(AsyncSnapshot<BaseResponse<List<Post>>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.data.length,
      itemBuilder: (context, index) {
        return PostItem(
          post: snapshot.data.data.elementAt(index),
          user: _bloc.user,
        );
      },
    );
  }
}