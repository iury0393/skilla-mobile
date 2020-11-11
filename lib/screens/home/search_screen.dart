import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/search_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/profile/profile_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _bloc = SearchBloc();

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
        child: Column(
          children: [
            ListTile(
              title: TextField(
                maxLines: 1,
                textCapitalization: TextCapitalization.none,
                controller: _bloc.searchUserController,
                style: TextStyles.textField(TextSize.medium),
                decoration: InputDecoration(
                  hintText: 'Procurar',
                  hintStyle:
                      TextStyles.paragraph(TextSize.small, color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      _bloc.searchUserController.clear();
                      onSearchTextChanged('');
                    },
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: onSearchTextChanged,
              ),
            ),
            StreamBuilder<BaseResponse<List<User>>>(
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
                        return _searchResult.length != 0 ||
                                _bloc.searchUserController.text.isNotEmpty
                            ? _buildListUser(users: _searchResult)
                            : _buildListUser(snapshot: snapshot);
                      } else {
                        return Align(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('textSearchWarning'),
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
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    print(text);
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
    }

    Utils.listOfUsers.forEach((user) {
      if (user.username.contains(text) || user.fullname.contains(text))
        _searchResult.add(user);
    });

    setState(() {});
  }

  List<User> _searchResult = [];

  Widget _buildListUser(
      {AsyncSnapshot<BaseResponse<List<User>>> snapshot, List<User> users}) {
    return Expanded(
      child: ListView.builder(
        itemCount: users != null ? users.length : snapshot.data.data.length,
        itemBuilder: (context, index) {
          return _buildRecomendation(
              user: users != null ? users[index] : snapshot.data.data[index]);
        },
      ),
    );
  }

  Column _buildRecomendation({User user}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: GestureDetector(
            child: user.email == _bloc.userEmail
                ? Container()
                : GestureDetector(
                    onTap: () {
                      _doNavigateToProfileScreen(user);
                    },
                    child: Row(
                      children: [
                        Utils.loadImage(user.avatar, context, true),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          user.username,
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
        ),
      ],
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
