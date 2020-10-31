import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/follower_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/profile/profile_screen.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class FollowerScreen extends StatefulWidget {
  final String id;
  const FollowerScreen({Key key, this.id}) : super(key: key);

  @override
  _FollowerScreenState createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  final _bloc = FollowerBloc();
  double _height = 40.0;
  double _width = 40.0;

  @override
  void initState() {
    super.initState();
    _bloc.getUser().then((value) {
      setState(() {
        _bloc.userEmail = value.data.email;
      });
    });
    _bloc.doRequestGetUsers();
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
      body: Padding(
        padding: Utils.getPaddingDefault(),
        child: StreamBuilder<BaseResponse<List<User>>>(
          stream: _bloc.followerController.stream,
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
                    return _buildListUser(snapshot);
                  } else {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Não existe ninguém lhe seguindo',
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
            }
            return Container();
          },
        ),
      ),
    );
  }

  ListView _buildListUser(AsyncSnapshot<BaseResponse<List<User>>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.data.length,
      itemBuilder: (context, index) {
        return _buildRecomendation(user: snapshot.data.data[index]);
      },
    );
  }

  Column _buildRecomendation({User user}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: _buildFollowersList(user),
        ),
      ],
    );
  }

  Widget _buildFollowersList(User user) {
    if (user.email != _bloc.userEmail) {
      return GestureDetector(
        onTap: () {
          _doNavigateToProfileScreen(user);
        },
        child: Row(
          children: [
            _loadImage(user.avatar),
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
      );
    } else {
      return Container();
    }
  }

  Widget _loadImage(String url) {
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        placeholder: (context, url) =>
            _buildPlaceholder(context, _height, _width),
        errorWidget: (context, url, error) =>
            _buildPlaceholder(context, _height, _width),
        imageUrl: url,
        height: _height,
        width: _width,
        fit: BoxFit.cover,
        imageBuilder: (context, imgProvider) {
          return _buildImageFromURL(imgProvider);
        },
      );
    }

    return _buildPlaceholder(context, _height, _width);
  }

  ClipRRect _buildPlaceholder(
      BuildContext context, double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  ClipRRect _buildImageFromURL(ImageProvider imgProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imgProvider,
          ),
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
