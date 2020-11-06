import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/bloc/sign_in_bloc.dart';
import 'package:skilla/components/custom_flushbar.dart';
import 'package:skilla/components/native_dialog.dart';
import 'package:skilla/components/rounded_button.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/tab_bar_screen.dart';
import 'package:skilla/screens/signFlow/sign_up_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _bloc = SignInBloc();

  @override
  void initState() {
    super.initState();
    _doSignInStream();
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
        child: Padding(
          padding: Utils.getPaddingDefault(),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ImageSkillaLogo(),
                _TextFormFields(bloc: _bloc),
                _BuildRegisterButton(),
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
    _bloc.loginController.stream.listen((event) {
      switch (event.status) {
        case Status.COMPLETED:
          _doNavigateToMainScreen();
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

  // >>>>>>>>>> NAVIGATOR

  _doNavigateToMainScreen() {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => TabBarScreen()),
        (route) => false);
  }
}

class _ImageSkillaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Hero(
        tag: 'logo',
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}

class _BuildSubmitButton extends StatelessWidget {
  final SignInBloc bloc;

  _BuildSubmitButton({this.bloc});

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      title: AppLocalizations.of(context).translate('btnLogin'),
      titleColor: Colors.white,
      borderColor: Colors.transparent,
      backgroundColor: kPurpleColor,
      onPressed: () {
        if (bloc.formKey.currentState.validate()) {
          bloc.doRequestLogin();
        }
      },
    );
  }
}

class _BuildRegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        _doNavigateToRegisterScreen(context);
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

  _doNavigateToRegisterScreen(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }
}

class _TextFormFields extends StatelessWidget {
  final SignInBloc bloc;

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
              formKey: bloc.formKey),
          SizedBox(
            height: 14,
          ),
          _TextFormField(
              mainController: bloc.textPasswordController,
              secondController: bloc.textEmailController,
              isPassword: true,
              hint: AppLocalizations.of(context)
                  .translate('fieldLoginRegisterPassword'),
              formKey: bloc.formKey)
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

  const _TextFormField(
      {this.mainController,
      this.secondController,
      this.isPassword,
      this.hint,
      this.formKey});
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
        if (widget.mainController.text.trim().isEmpty &&
            widget.secondController.text.trim().isEmpty) {
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
      },
    );
  }
}
