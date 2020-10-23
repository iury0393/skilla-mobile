import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/sign_in_bloc.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/tab_bar_screen.dart';
import 'package:skilla/screens/signFlow/sign_up_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/manager_dialogs.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'signInScreen';
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _bloc = SignInBloc();

  @override
  void initState() {
    super.initState();

    _bloc.loginStreamController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          _doNavigateMainScreen();
          break;
        case Status.LOADING:
          ManagerDialogs.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Navigator.pop(context);
          ManagerDialogs.showErrorDialog(
              context, event.status.toString(), event.message);
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Utils.getPaddingDefault(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/logo.png'),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Form(
                  key: _bloc.formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: _buildEmailTextFormField(),
                      ),
                      _buildPasswordTextFormField(),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  _buildSubmitButton(),
                  _buildRegisterButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //BUTTONS

  Widget _buildRegisterButton() {
    return FlatButton(
      onPressed: () {
        _doNavigateRegisterScreen();
      },
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: AppLocalizations.of(context).translate('btnRegisterText'),
          style: TextStyles.paragraph(
            TextSize.medium,
          ),
          children: [
            TextSpan(
              text: AppLocalizations.of(context).translate('btnLink'),
              style: TextStyles.paragraph(
                TextSize.medium,
                color: kPurpleColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return RoundedButton(
      title: AppLocalizations.of(context).translate('btnLogin'),
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () {
        if (_bloc.formKey.currentState.validate()) {
          _bloc.doRequestLogin();
        }
      },
    );
  }

  //TEXT FORM FIELDS

  TextFormField _buildEmailTextFormField() {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: _bloc.textEmailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).translate('fieldEmail'),
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
      ),
      onFieldSubmitted: (text) {
        if (_bloc.isEmailErrorDisplayed) {
          _bloc.formKey.currentState.validate();
        }
      },
      validator: (text) {
        if (text.trim().isEmpty) {
          _bloc.isEmailErrorDisplayed = true;
          _showSnackBar(AppLocalizations.of(context)
              .translate('fieldEmailValidatorEmpty'));
          return "";
        }

        if (!Utils.validateEmail(text)) {
          _bloc.isEmailErrorDisplayed = true;
          _showSnackBar(AppLocalizations.of(context)
              .translate('fieldEmailValidatorInvalid'));
          return "";
        }

        _bloc.isEmailErrorDisplayed = false;
        return null;
      },
    );
  }

  Widget _buildPasswordTextFormField() {
    return StreamBuilder<bool>(
        stream: _bloc.obfuscatePasswordStreamController.stream,
        initialData: true,
        builder: (context, snapshot) {
          return TextFormField(
            textCapitalization: TextCapitalization.none,
            controller: _bloc.textPasswordController,
            obscureText: snapshot.data,
            style: TextStyles.textField(TextSize.medium),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).translate('fieldPassword'),
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.vpn_key),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              fillColor: Colors.white,
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                    snapshot.data ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  _bloc.obfuscatePasswordStreamController.add(!snapshot.data);
                },
              ),
            ),
            onFieldSubmitted: (text) {
              if (_bloc.isPasswordErrorDisplayed) {
                _bloc.formKey.currentState.validate();
              }
            },
            validator: (text) {
              if (text.trim().isEmpty) {
                _bloc.isPasswordErrorDisplayed = true;
                _showSnackBar(AppLocalizations.of(context)
                    .translate('fieldPasswordValidator'));
                return "";
              }

              _bloc.isPasswordErrorDisplayed = false;
              return null;
            },
          );
        });
  }

  //NAVIGATION

  void _doNavigateMainScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      TabBarScreen.id,
      (route) => false,
    );
  }

  void _doNavigateRegisterScreen() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }

  //SNACKBAR

  void _showSnackBar(String text) {
    Flushbar(
      message: text,
      duration: Duration(seconds: 3),
      backgroundColor: kRedColor,
    )..show(context);
  }
}
