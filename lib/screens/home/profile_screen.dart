import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/profile_bloc.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profileScreen';
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _bloc = ProfileBloc();

  double _height = 120.0;
  double _width = 120.0;

  @override
  void initState() {
    super.initState();
    _bloc.getUserData();
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
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: Utils.getPaddingDefault(),
            child: Column(
              children: [
                StreamBuilder<BaseResponse<String>>(
                  stream: _bloc.avatarController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data.data != null) {
                      if (snapshot.data.data.isNotEmpty) {
                        return _loadImage(snapshot.data?.data);
                      }
                    }
                    return _buildPlaceholder(context, _height, _width);
                  },
                ),
                StreamBuilder<BaseResponse<String>>(
                    stream: _bloc.userNameController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data.data != null) {
                        if (snapshot.data.data.isNotEmpty) {
                          return Text(
                            snapshot.data?.data,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.paragraph(
                              TextSize.xxLarge,
                              weight: FontWeight.w400,
                            ),
                          );
                        }
                      }
                      return Container();
                    }),
                IconButton(
                  icon: Icon(
                    FeatherIcons.edit,
                    color: kSkillaPurple,
                  ),
                  onPressed: () {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '1 Post',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.paragraph(
                        TextSize.medium,
                        weight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        '5 Seguidores',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.paragraph(
                          TextSize.medium,
                          weight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {},
                    ),
                    GestureDetector(
                      child: Text(
                        '5 Seguindo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.paragraph(
                          TextSize.medium,
                          weight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                  child: StreamBuilder<BaseResponse<String>>(
                      stream: _bloc.fullNameController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data.data != null) {
                          if (snapshot.data.data.isNotEmpty) {
                            return Text(
                              snapshot.data?.data,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.paragraph(
                                TextSize.large,
                                weight: FontWeight.w400,
                              ),
                            );
                          }
                        }
                        return Container();
                      }),
                ),
                StreamBuilder<BaseResponse<String>>(
                    stream: _bloc.bioController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data.data != null) {
                        if (snapshot.data.data.isNotEmpty) {
                          return Text(
                            snapshot.data?.data,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.paragraph(
                              TextSize.large,
                              weight: FontWeight.w400,
                            ),
                          );
                        }
                      }
                      return Container();
                    }),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: _buildSubmitButton(),
                ),
                Divider(
                  height: 20.0,
                  thickness: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FeatherIcons.archive,
                      color: kSkillaPurple,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Posts',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.paragraph(
                        TextSize.medium,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/post.jpg',
                        width: width / 4,
                        height: height / 4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/post.jpg',
                        width: width / 4,
                        height: height / 4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RoundedButton(
      width: 100.0,
      height: 30.0,
      title: 'Curriculo',
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () {},
    );
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
}
