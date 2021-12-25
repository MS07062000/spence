import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:muraliapp/login_signup_widgets/login.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 18.0,
      fontFamily: 'Helvetica',
      color: Colors.black,
    );

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'Arial',
      ),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: const SizedBox(
        width: double.infinity,
        height: 60,
      ),
      globalFooter: const SizedBox(
        width: double.infinity,
        height: 60,
      ),
      pages: [
        PageViewModel(
          title: "Manage like a pro",
          body:
              "Have the perfect oversight and inventory over all your household items",
          image: _buildImage('intro1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Get alerts",
          body: "Never miss a notification or a reminder with us",
          image: _buildImage('intro2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create Shopping list",
          body:
              "Have all your pantry and grocery requirements listed in one place",
          image: _buildImage('intro3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Say no to wastage",
          body: "Start your journey of never wasting a product again",
          image: _buildImage('intro4.png'),
          decoration: pageDecoration,
          footer: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _onIntroEnd(context);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      showDoneButton: false,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text(
        'Skip',
        style: TextStyle(
            fontWeight: FontWeight.w600, color: Colors.orange, fontSize: 20),
      ),
      next: const Icon(Icons.arrow_forward, color: Colors.orange),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.orange,
        activeColor: Colors.orange,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
