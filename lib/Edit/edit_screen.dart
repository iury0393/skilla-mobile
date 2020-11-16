import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skilla/Edit/edit_bloc.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/components/custom_app_bar.dart';
import 'package:skilla/utils/components/custom_flushbar.dart';
import 'package:skilla/utils/components/native_dialog.dart';
import 'package:skilla/utils/components/native_loading.dart';
import 'package:skilla/utils/components/rounded_button.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/firebase_instance.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class EditScreen extends StatefulWidget {
  final User user;
  EditScreen({Key key, this.user}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  EditBloc _bloc;
  File _image;
  final picker = ImagePicker();
  bool isLoading = false;
  bool isAvatar = false;

  @override
  void initState() {
    super.initState();
    _bloc = EditBloc(widget.user);
    _doEditStream();
    FirebaseInstance.getFirebaseInstance().setCurrentScreen(
        screenName: kScreenNameEdit,
        screenClassOverride: kScreenClassOverrideEdit);
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
        titleImg: kAppBarImg,
        center: true,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: NativeLoading(animating: true),
              )
            : Padding(
                padding: Utils.getPaddingDefault(),
                child: Column(
                  children: [
                    _buildAvatar(context),
                    _BuildFullName(
                      bloc: _bloc,
                    ),
                    _BuildUserName(
                      bloc: _bloc,
                    ),
                    _BuildWebsite(
                      bloc: _bloc,
                    ),
                    _BuildBio(
                      bloc: _bloc,
                    ),
                    _buildSubmitButton(),
                  ],
                ),
              ),
      ),
    );
  }

  // >>>>>>>>>> STREAMS

  _doEditStream() {
    _bloc.editController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          refreshProfileWhenEdit(true);
          Navigator.pop(context);
          _bloc.textFullNameController.clear();
          _bloc.textUserNameController.clear();
          _bloc.textWebsiteController.clear();
          _bloc.textBioController.clear();
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

  // >>>>>>>>>> EVENTS

  void refreshProfileWhenEdit(isEdited) {
    EventCenter.getInstance().editEvent.broadcast(EditEventArgs(isEdited));
  }

  // >>>>>>>>>> FUNCTIONS

  Future getImageCamera() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        NativeDialog.showErrorDialog(context,
            AppLocalizations.of(context).translate('textImagePickerWarning'));
      }
    });
  }

  Future getImageGallery() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        NativeDialog.showErrorDialog(context,
            AppLocalizations.of(context).translate('textImagePickerWarning'));
      }
    });
  }

  Future uploadImage() async {
    setState(() {
      isLoading = true;
    });
    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        _image.path,
      ),
      "upload_preset": kUploadPreset,
      "cloud_name": kCloudName,
    });
    try {
      Response response = await dio.post(kApiBaseUrl, data: formData);

      var data = jsonDecode(response.toString());
      print(data['secure_url']);
      setState(() {
        isLoading = false;
      });
      return data['secure_url'];
    } catch (e) {
      print(e);
    }
  }

  // >>>>>>>>>> WIDGETS

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: RoundedButton(
        width: 100.0,
        height: 30.0,
        title: AppLocalizations.of(context).translate('btnEditSubmit'),
        titleColor: Colors.white,
        borderColor: Colors.transparent,
        backgroundColor: kPurpleColor,
        onPressed: () async {
          FirebaseAnalytics().logEvent(name: kNameEdit, parameters: null);
          if (isAvatar) {
            var response = await uploadImage();
            _bloc.doRequestEdit(secureUrl: response);
          } else {
            _bloc.getUser().then((value) {
              var response = value.data.avatar;
              _bloc.doRequestEdit(secureUrl: response);
            });
          }
        },
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: _image == null
              ? Utils.loadImage(widget.user.avatar, context, false)
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 55,
                  child: Image.file(
                    _image,
                  ),
                ),
        ),
        _buildTextBtn(context),
      ],
    );
  }

  Widget _buildTextBtn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 180,
          child: Text(
            widget.user.username,
            style: TextStyles.paragraph(
              TextSize.large,
              weight: FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            width: 180.0,
            child: Text(
              AppLocalizations.of(context).translate('textEditBtnImage'),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyles.paragraph(
                TextSize.medium,
                weight: FontWeight.w400,
                color: Color(0xFF4998F5),
              ),
            ),
          ),
          onTap: () {
            FirebaseAnalytics()
                .logEvent(name: kNameEditAvatar, parameters: null);
            isAvatar = true;
            _showDialogForUser(context);
          },
        ),
      ],
    );
  }

  // >>>>>>>>>> DIALOGS

  void _showDialogForUser(BuildContext context) {
    showNativeDialog(
      context: context,
      builder: (context) => NativeDialog(
        title: AppLocalizations.of(context)
            .translate('textPostDetailDialogTitlePost'),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textCamera'),
                style: TextStyles.paragraph(TextSize.xSmall)),
            onPressed: () {
              Navigator.pop(context);
              getImageCamera();
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textGallery'),
                style: TextStyles.paragraph(TextSize.xSmall)),
            onPressed: () {
              Navigator.pop(context);
              getImageGallery();
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('textCancel'),
                style: TextStyles.paragraph(TextSize.xSmall, color: kRedColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _BuildFullName extends StatelessWidget {
  final EditBloc bloc;

  _BuildFullName({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: _buildFullNameTextFormField(context),
    );
  }

  TextFormField _buildFullNameTextFormField(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: bloc.textFullNameController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText:
            AppLocalizations.of(context).translate('textFieldEditNameHint'),
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}

class _BuildUserName extends StatelessWidget {
  final EditBloc bloc;

  _BuildUserName({this.bloc});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: _buildUserNameTextFormField(context),
    );
  }

  TextFormField _buildUserNameTextFormField(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: bloc.textUserNameController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText:
            AppLocalizations.of(context).translate('textFieldEditUserHint'),
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        prefixIcon: Icon(Icons.person_pin),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
      onFieldSubmitted: (text) {
        if (bloc.isUserNameErrorDisplayed) {
          bloc.formKey.currentState.validate();
        }
      },
      validator: (text) {
        if (text.trim().isEmpty) {
          bloc.isUserNameErrorDisplayed = true;
          CustomFlushBar.showFlushBar(
            AppLocalizations.of(context).translate('textFieldEditUserWarning'),
            context,
          );
          return "";
        }

        bloc.isUserNameErrorDisplayed = false;
        return null;
      },
    );
  }
}

class _BuildWebsite extends StatelessWidget {
  final EditBloc bloc;

  _BuildWebsite({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: _buildWebsiteTextFormField(context),
    );
  }

  TextFormField _buildWebsiteTextFormField(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: bloc.textWebsiteController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText:
            AppLocalizations.of(context).translate('textFieldEditWebHint'),
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        prefixIcon: Icon(Icons.account_circle),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}

class _BuildBio extends StatelessWidget {
  final EditBloc bloc;

  _BuildBio({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25.0),
      child: _buildBioTextFormField(context),
    );
  }

  TextFormField _buildBioTextFormField(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: bloc.textBioController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText:
            AppLocalizations.of(context).translate('textFieldEditBioHint'),
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        prefixIcon: Icon(Icons.text_format),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
