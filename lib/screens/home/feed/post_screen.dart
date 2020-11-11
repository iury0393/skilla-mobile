import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skilla/bloc/post_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/native_loading.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _bloc = PostBloc();
  File _image;
  final picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _doPostStream();
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
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: NativeLoading(animating: true),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                padding: Utils.getPaddingDefault(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image == null
                        ? Column(
                            children: [
                              GestureDetector(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      color: kSkillaPurple,
                                    ),
                                    Container(
                                      width: 210,
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('textCameraPost'),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyles.paragraph(
                                            TextSize.medium,
                                            color: kSkillaPurple,
                                            isLink: true),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  getImageCamera();
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: GestureDetector(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        color: kSkillaPurple,
                                      ),
                                      Container(
                                        width: 210,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate('textGalleryPost'),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyles.paragraph(
                                              TextSize.medium,
                                              color: kSkillaPurple,
                                              isLink: true),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    getImageGallery();
                                  },
                                ),
                              )
                            ],
                          )
                        : Image.file(
                            _image,
                            height: MediaQuery.of(context).size.height / 2,
                          ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: _buildCaptionTextField(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: _buildSubmitButton(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // >>>>>>>>>> STREAMS

  _doPostStream() {
    _bloc.postController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          refreshFeedWithNewPost(true);
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

  // >>>>>>>>>> EVENTS

  void refreshFeedWithNewPost(isNewPost) {
    EventCenter.getInstance()
        .newPostEvent
        .broadcast(NewPostEventArgs(isNewPost));
  }

  // >>>>>>>>>> WIDGETS

  Widget _buildCaptionTextField() {
    return TextField(
      maxLines: 1,
      textCapitalization: TextCapitalization.none,
      controller: _bloc.textCaptionController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).translate('textFieldPostHint'),
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RoundedButton(
      title: AppLocalizations.of(context).translate('btnPostSubmit'),
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () async {
        var response = await uploadImage();

        _bloc.doRequestAddPost(response);
      },
    );
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
}
