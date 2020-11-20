import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:skilla/SignIn/sign_in_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    super.initState();
    _retrieveDynamicLink(context);
  }

  Future<void> _retrieveDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        print(deepLink.queryParameters['code']);
        Get.to(
          IntroScreen(),
          transition: Transition.native,
          duration: Duration(milliseconds: 500),
        );
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      Get.to(
        IntroScreen(),
        transition: Transition.native,
        duration: Duration(milliseconds: 500),
      );
    }
  }

  void _onIntroEnd(context) {
    Get.to(
      SignInScreen(),
      transition: Transition.native,
      duration: Duration(milliseconds: 500),
    );
  }

  void _onSkip(context) {
    Get.to(
      SignInScreen(),
      transition: Transition.native,
      duration: Duration(milliseconds: 500),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.network(assetName, width: 400.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, fontFamily: 'Roboto');
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.w700, fontFamily: 'Roboto'),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title:
              AppLocalizations.of(context).translate('introOpportunitiesTitle'),
          body:
              AppLocalizations.of(context).translate('introOpportunitiesText'),
          image: _buildImage(kIntro1),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title:
              AppLocalizations.of(context).translate('introPublicationsTitle'),
          body: AppLocalizations.of(context).translate('introPublicationsText'),
          image: _buildImage(kIntro2),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context).translate('introCoursesTitle'),
          body: AppLocalizations.of(context).translate('introCoursesText'),
          image: _buildImage(kIntro3),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onSkip(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(
        'Pular',
        style: TextStyles.paragraph(
          TextSize.medium,
          weight: FontWeight.w500,
        ),
      ),
      next: Icon(Icons.arrow_forward),
      done: Text(
        'Feito',
        style: TextStyles.paragraph(
          TextSize.medium,
          weight: FontWeight.w500,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
