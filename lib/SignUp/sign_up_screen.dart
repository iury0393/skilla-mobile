import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skilla/SignUp/sign_up_bloc.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/components/custom_flushbar.dart';
import 'package:skilla/utils/components/native_dialog.dart';
import 'package:skilla/utils/components/rounded_button.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/firebase_instance.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _bloc = SignUpBloc();

  @override
  void initState() {
    super.initState();
    _doSignInStream();
    FirebaseInstance.getFirebaseInstance().setCurrentScreen(
        screenName: kScreenNameSignUp,
        screenClassOverride: kScreenClassOverrideSignUp);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: Utils.getPaddingDefault(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ImageSkillaLogo(),
                _TextFormFields(bloc: _bloc),
                _BuildLoginButton(),
                _BuildSubmitButton(bloc: _bloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // >>>>>>>>>> STREAM

  _doSignInStream() {
    _bloc.registerController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          Get.back();
          Get.back();
          break;
        case Status.LOADING:
          NativeDialog.showLoadingDialog(context);
          break;
        case Status.ERROR:
          Get.back();
          NativeDialog.showErrorDialog(context, event.message);
          break;
        default:
          break;
      }
    });
  }
}

class _ImageSkillaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Image.network(kLogo),
    );
  }
}

class _BuildSubmitButton extends StatelessWidget {
  final SignUpBloc bloc;

  _BuildSubmitButton({this.bloc});

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      title: AppLocalizations.of(context).translate('btnRegister'),
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () {
        FirebaseAnalytics().logEvent(name: kNameSignUp, parameters: null);
        if (bloc.formKey.currentState.validate()) {
          bloc.doRequestRegister();
        }
      },
    );
  }
}

class _BuildLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        FirebaseAnalytics()
            .logEvent(name: kNameNavigateSignIn, parameters: null);
        Get.back();
      },
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: AppLocalizations.of(context).translate('btnLoginText'),
          style: TextStyles.paragraph(
            TextSize.medium,
          ),
          children: [
            TextSpan(
              text: AppLocalizations.of(context)
                  .translate('btnLoginRegisterLink'),
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
}

class _TextFormFields extends StatelessWidget {
  final SignUpBloc bloc;

  const _TextFormFields({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: bloc.formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 78,
          ),
          _TextFormField(
            mainController: bloc.textEmailController,
            secondController: bloc.textPasswordController,
            isPassword: false,
            hint: AppLocalizations.of(context)
                .translate('fieldLoginRegisterEmail'),
            formKey: bloc.formKey,
            isPrincipal: true,
          ),
          SizedBox(
            height: 14,
          ),
          _TextFormField(
            mainController: bloc.textFullNameController,
            secondController: bloc.textPasswordController,
            isPassword: false,
            hint: AppLocalizations.of(context)
                .translate('fieldLoginRegisterName'),
            formKey: bloc.formKey,
            isPrincipal: false,
          ),
          SizedBox(
            height: 14,
          ),
          _TextFormField(
            mainController: bloc.textUserNameController,
            secondController: bloc.textPasswordController,
            isPassword: false,
            hint: AppLocalizations.of(context)
                .translate('fieldLoginRegisterUsername'),
            formKey: bloc.formKey,
            isPrincipal: false,
          ),
          SizedBox(
            height: 14,
          ),
          _TextFormField(
            mainController: bloc.textPasswordController,
            secondController: bloc.textEmailController,
            isPassword: true,
            hint: AppLocalizations.of(context)
                .translate('fieldLoginRegisterPassword'),
            formKey: bloc.formKey,
            isPrincipal: true,
          )
        ],
      ),
    );
  }
}

class _TextFormField extends StatefulWidget {
  final TextEditingController mainController;
  final TextEditingController secondController;
  final bool isPassword;
  final String hint;
  final GlobalKey<FormState> formKey;
  final bool isPrincipal;

  const _TextFormField(
      {this.mainController,
      this.secondController,
      this.isPassword,
      this.hint,
      this.formKey,
      this.isPrincipal});
  @override
  __TextFormFieldState createState() => __TextFormFieldState();
}

class __TextFormFieldState extends State<_TextFormField> {
  bool _errorDisplayed = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      controller: widget.mainController,
      obscureText: widget.isPassword ? _obscureText : false,
      style: TextStyles.textField(TextSize.medium),
      decoration: InputDecoration(
        errorStyle: TextStyle(height: 0),
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                })
            : null,
      ),
      onFieldSubmitted: (text) {
        if (_errorDisplayed) {
          widget.formKey.currentState.validate();
        }
      },
      validator: (text) {
        if (widget.isPrincipal) {
          if (widget.mainController.text.trim().isEmpty) {
            _errorDisplayed = true;
            CustomFlushBar.showFlushBar(
                AppLocalizations.of(context).translate('fieldsEmpty'), context);
            return "";
          }

          if (!widget.isPassword) {
            if (!Utils.validateEmail(widget.mainController.text.trim())) {
              CustomFlushBar.showFlushBar(
                  AppLocalizations.of(context)
                      .translate('fieldLoginRegisterEmailValidatorInvalid'),
                  context);
              return "";
            }
          }

          if (widget.mainController.text.trim().isEmpty) {
            _errorDisplayed = true;
            CustomFlushBar.showFlushBar(
                AppLocalizations.of(context).translate(widget.isPassword
                    ? 'fieldLoginRegisterPasswordValidator'
                    : 'fieldLoginRegisterEmailValidatorEmpty'),
                context);
            return "";
          }

          _errorDisplayed = false;
          return null;
        }
        _errorDisplayed = false;
        return null;
      },
    );
  }
}
