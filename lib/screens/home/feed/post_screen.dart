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
import 'package:skilla/utils/constants.dart';
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
  bool isloading = false;

  @override
  void initState() {
    super.initState();

    _bloc.postController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
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
    _bloc.dispose();
  }

  Future getImageCamera() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        NativeDialog.showErrorDialog(context, "Imagem não selecionada");
      }
    });
  }

  Future getImageGallery() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        NativeDialog.showErrorDialog(context, "Imagem não selecionada");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleImg: 'assets/navlogo.png',
        center: true,
      ),
      body: SingleChildScrollView(
        child: isloading
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
                                        'Selecione uma imagem da câmera do seu celular',
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
                                          'Selecione uma imagem da galeria do seu celular',
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

  TextField _buildCaptionTextField() {
    return TextField(
      maxLines: 1,
      textCapitalization: TextCapitalization.none,
      controller: _bloc.textCaptionController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText: 'Adicione uma legenda',
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RoundedButton(
      title: 'Postar',
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () async {
        var response = await uploadImage();

        _bloc.doRequestAddPost(response);
      },
    );
  }

  Future uploadImage() async {
    setState(() {
      isloading = true;
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
        isloading = false;
      });
      return data['secure_url'];
    } catch (e) {
      print(e);
    }
  }
}
