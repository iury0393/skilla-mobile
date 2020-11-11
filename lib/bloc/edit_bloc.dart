import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/edit_network.dart';
import 'package:skilla/network/user_network.dart';
import 'package:skilla/utils/utils.dart';

class EditBloc {
  User user;
  UserNetwork _userService = UserNetwork();
  TextEditingController textAvatarController;
  TextEditingController textFullNameController;
  TextEditingController textUserNameController;
  TextEditingController textWebsiteController;
  TextEditingController textBioController;

  StreamController<BaseResponse<dynamic>> editController;

  String fullName;
  String userName;
  String website;
  String bio;

  String defaultImg =
      "https://res.cloudinary.com/duujebpq4/image/upload/v1593622790/profilePic_r6aau3.jpg";

  GlobalKey<FormState> formKey;

  bool isUserNameErrorDisplayed = false;

  EditBloc(this.user) {
    formKey = GlobalKey<FormState>();
    textAvatarController = TextEditingController();
    textFullNameController = TextEditingController();
    textUserNameController = TextEditingController();
    textWebsiteController = TextEditingController();
    textBioController = TextEditingController();
    editController = StreamController();
  }

  dispose() {
    textAvatarController.dispose();
    textFullNameController.dispose();
    textUserNameController.dispose();
    textWebsiteController.dispose();
    textBioController.dispose();
    editController.close();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  doRequestEdit({String secureUrl}) async {
    editController.add(BaseResponse.loading());
    try {
      var body = User(
        avatar: secureUrl,
        fullname: textFullNameController.text == ""
            ? ""
            : textFullNameController.text,
        username: textUserNameController.text,
        website:
            textWebsiteController.text == "" ? "" : textWebsiteController.text,
        bio: textBioController.text == "" ? "" : textBioController.text,
      ).toJson();
      await EditNetwork().doRequestEdit(body);
      _doRequestGetUserLoggedData();
      editController.add(BaseResponse.completed());
    } catch (e) {
      editController.add(BaseResponse.error(e.toString()));
    }
  }

  _doRequestGetUserLoggedData() async {
    try {
      var userResponse = await _userService.doRequestGetUser();
      userResponse.email = user.email;
      _updateUserInDB(userResponse);
    } catch (e) {
      editController.add(BaseResponse.error(e.toString()));
    }
  }

  _updateUserInDB(User userData) async {
    try {
      User user = User().generateDataFromUser(userData);
      print(user);
      _saveUserInDB(user);
    } catch (e) {
      editController.add(BaseResponse.error(e.toString()));
    }
  }

  _saveUserInDB(User user) async {
    try {
      await Utils.cleanDataBaseUser();
      await UserDAO().save(user);
      editController.add(BaseResponse.completed());
    } catch (e) {
      editController.add(BaseResponse.error(e.toString()));
    }
  }
}
