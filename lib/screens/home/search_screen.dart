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
import 'package:skilla/utils/firebase_instance.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _bloc = SearchBloc();
  List<User> _searchResult = [];

  @override
  void initState() {
    super.initState();
    _onInit();
    FirebaseInstance.getFirebaseInstance().setCurrentScreen(
        screenName: "signIn", screenClassOverride: "SignInPage");
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
            _buildSearchTile(),
            _searchResult.length != 0 ||
                    _bloc.searchUserController.text.isNotEmpty
                ? _BuildStream(
                    bloc: _bloc,
                    users: _searchResult,
                    isSearch: true,
                  )
                : _BuildStream(
                    bloc: _bloc,
                    isSearch: false,
                  ),
          ],
        ),
      ),
    );
  }

  _onInit() {
    _bloc.getUser().then((value) {
      setState(() {
        _bloc.userEmail = value.data.email;
      });
    });
    _bloc.doRequestGetUsers();
  }

  // >>>>>>>>>> WIDGETS

  Widget _buildSearchTile() {
    return ListTile(
      title: TextField(
        maxLines: 1,
        textCapitalization: TextCapitalization.none,
        controller: _bloc.searchUserController,
        style: TextStyles.textField(TextSize.medium),
        decoration: InputDecoration(
          hintText: 'Procurar',
          hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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
    );
  }

  // >>>>>>>>>> FUNCTIONS

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
}

class _BuildStream extends StatefulWidget {
  final SearchBloc bloc;
  final List<User> users;
  final bool isSearch;

  _BuildStream({this.bloc, this.isSearch = false, this.users});
  @override
  __BuildStreamState createState() => __BuildStreamState();
}

class __BuildStreamState extends State<_BuildStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseResponse<List<User>>>(
      stream: widget.bloc.recommendedController.stream,
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
                return widget.isSearch
                    ? _BuildList(
                        users: widget.users,
                        bloc: widget.bloc,
                      )
                    : _BuildList(
                        snapshot: snapshot,
                        bloc: widget.bloc,
                      );
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).translate('textSearchWarning'),
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
    );
  }
}

class _BuildList extends StatefulWidget {
  final AsyncSnapshot<BaseResponse<List<User>>> snapshot;
  final List<User> users;
  final SearchBloc bloc;

  _BuildList({this.snapshot, this.users, this.bloc});
  @override
  __BuildListState createState() => __BuildListState();
}

class __BuildListState extends State<_BuildList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.users != null
            ? widget.users.length
            : widget.snapshot.data.data.length,
        itemBuilder: (context, index) {
          return _BuildRecommendation(
            user: widget.users != null
                ? widget.users[index]
                : widget.snapshot.data.data[index],
            bloc: widget.bloc,
          );
        },
      ),
    );
  }
}

class _BuildRecommendation extends StatelessWidget {
  final User user;
  final SearchBloc bloc;

  _BuildRecommendation({this.user, this.bloc});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: GestureDetector(
            child: user.email == bloc.userEmail
                ? Container()
                : GestureDetector(
                    onTap: () {
                      _doNavigateToProfileScreen(user, context);
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

  // >>>>>>>>>> NAVIGATORS

  _doNavigateToProfileScreen(User user, BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProfileScreen(
          user: user,
        ),
      ),
    );
  }
}
