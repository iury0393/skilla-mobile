import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/edit_bloc.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
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

  @override
  void initState() {
    super.initState();
    _bloc = EditBloc(widget.user);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleImg: 'assets/navlogo.png',
        center: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Utils.getPaddingDefault(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Utils.loadImage(widget.user.avatar, context, false),
                  ),
                  Column(
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
                            'Troque a imagem do seu perfil',
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
                          //TODO: Trocar imagem do perfil, deixar lista de posts de 3 em 3 por linha
                          print("Trocar imagem do perfil");
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0),
                child: _buildFullNameTextFormField(),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0),
                child: _buildUserNameTextFormField(),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0),
                child: _buildWebsiteTextFormField(),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0),
                child: _buildBioTextFormField(),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0),
                child: _buildSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RoundedButton(
      width: 100.0,
      height: 30.0,
      title: 'Submit',
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () {
        _bloc.doRequestEdit();
      },
    );
  }

  void refreshProfileWhenEdit(isEdited) {
    EventCenter.getInstance().editEvent.broadcast(EditEventArgs(isEdited));
  }

  TextFormField _buildFullNameTextFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: _bloc.textFullNameController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText: 'Nome',
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  TextFormField _buildUserNameTextFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: _bloc.textUserNameController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText: 'Usuário',
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        prefixIcon: Icon(Icons.person_pin),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
      onFieldSubmitted: (text) {
        if (_bloc.isUserNameErrorDisplayed) {
          _bloc.formKey.currentState.validate();
        }
      },
      validator: (text) {
        if (text.trim().isEmpty) {
          _bloc.isUserNameErrorDisplayed = true;
          _showSnackBar('O campo do nome do usuário não pode estar vazio.');
          return "";
        }

        _bloc.isUserNameErrorDisplayed = false;
        return null;
      },
    );
  }

  TextFormField _buildWebsiteTextFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: _bloc.textWebsiteController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText: 'Website',
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        prefixIcon: Icon(Icons.account_circle),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  TextFormField _buildBioTextFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: _bloc.textBioController,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText: 'Bio',
        hintStyle: TextStyles.paragraph(TextSize.small, color: Colors.grey),
        prefixIcon: Icon(Icons.text_format),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  void _showSnackBar(String text) {
    Flushbar(
      message: text,
      duration: Duration(seconds: 3),
      backgroundColor: kRedColor,
    )..show(context);
  }
}
