import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skilla/bloc/post_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
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

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

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
      body: Padding(
        padding: Utils.getPaddingDefault(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          color: kSkillaPurple,
                        ),
                        Text(
                          'Selecione uma imagem do seu celular',
                          style: TextStyles.paragraph(TextSize.medium,
                              color: kSkillaPurple, isLink: true),
                        ),
                      ],
                    ),
                    onTap: getImage,
                  )
                : Image.file(_image),
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
      onPressed: () {},
    );
  }
}
