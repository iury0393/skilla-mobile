import 'package:flutter/material.dart';
import 'package:skilla/bloc/search_bloc.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'searchScreen';
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _bloc = SearchBloc();

  @override
  void initState() {
    super.initState();
    _bloc.getUser();
    _bloc.doRequestGetUsers();
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
        body: Column(
          children: [
            Padding(
              padding: Utils.getPaddingDefault(),
              child: StreamBuilder<BaseResponse<List<User>>>(
                stream: _bloc.recommendedController.stream,
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
                          return ListView.builder(
                            itemCount: snapshot.data.data.length,
                            itemBuilder: (context, index) {
                              return Text(
                                'Não existe mais ninguém para seguir',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.paragraph(
                                  TextSize.large,
                                  weight: FontWeight.w400,
                                  color: kSkillaPurple,
                                ),
                              );
                            },
                          );
                        } else {
                          return Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Não existe mais ninguém para seguir',
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
          ],
        ),
      ),
    );
  }

  Column _buildRecomendation({User user}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: GestureDetector(
            child: Row(
              children: [
                Image.asset(
                  'assets/default_avatar.jpg',
                  width: 40.0,
                  height: 40.0,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  'Iury Vasconcelos',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.paragraph(
                    TextSize.large,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
