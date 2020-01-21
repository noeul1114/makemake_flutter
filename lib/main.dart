import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';

import 'mainScreen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        backgroundColor: Colors.grey[200],
        child: SignUpScreen(),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Card(
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}


class _SignUpFormState extends State<SignUpForm>
    with SingleTickerProviderStateMixin {
  // STEP 3: Add an AnimationController and add the
  // AnimatedBuilder with a LinearProgressIndicator to the Column
  bool _formCompleted = false;

  AnimationController animationController;
  Animation<Color> colorAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    var colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    colorAnimation = animationController.drive(colorTween);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: animationController.value,
              valueColor: colorAnimation,
              backgroundColor: colorAnimation.value.withOpacity(0.4),
            );
          },
        ),
        SignUpFormBody(
          onProgressChanged: (progress) {
            // STEP 2: Create a _formCompleted field on this class
            // and set it here when the progress is 1
            if (!animationController.isAnimating) {
              animationController.animateTo(progress);
            }
            setState(() {
              _formCompleted = progress == 1;
            });
          },
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.all(12),
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            // STEP 1: Add a callback here and navigate to
            // the welcome screen when the button is tapped.
            onPressed: _formCompleted ? _showWelcomeScreen : null,
            child: Text('Sign up'),
          ),
        ),
      ],
    );
  }

  void _showWelcomeScreen() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => MainScreen()));
  }
}

class SignUpFormBody extends StatefulWidget {
  final ValueChanged<double> onProgressChanged;

  SignUpFormBody({
    @required this.onProgressChanged,
  }) : assert(onProgressChanged != null);

  @override
  _SignUpFormBodyState createState() => _SignUpFormBodyState();
}

class _SignUpFormBodyState extends State<SignUpFormBody> {
  static const EdgeInsets padding = EdgeInsets.all(8);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  List<TextEditingController> get controllers =>
      [emailController, phoneController, websiteController];

  @override
  void initState() {
    super.initState();
    controllers.forEach((ab) => ab.addListener(() => _updateProgress()));
  }

  double get _formProgress {
    var progress = 0.0;
    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }
    return progress;
  }

  void _updateProgress() {
    widget.onProgressChanged(_formProgress);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding,
            child: Center(
                child: Text('Sign up',
                    style: Theme.of(context).textTheme.display1)),
          ),
          CupertinoTextField(
            prefix: const Icon(
              CupertinoIcons.person_solid,
              color: CupertinoColors.lightBackgroundGray,
              size: 28,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            clearButtonMode: OverlayVisibilityMode.editing,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            placeholder: 'E-mail address',
            controller: emailController,
          ),
          CupertinoTextField(
            prefix: const Icon(
              CupertinoIcons.phone_solid,
              color: CupertinoColors.lightBackgroundGray,
              size: 28,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            clearButtonMode: OverlayVisibilityMode.editing,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            placeholder: 'Phone number',
            controller: phoneController,
          ),
          CupertinoTextField(
            prefix: const Icon(
              CupertinoIcons.location_solid,
              color: CupertinoColors.lightBackgroundGray,
              size: 28,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            clearButtonMode: OverlayVisibilityMode.editing,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            placeholder: 'Website',
            controller: websiteController,
          ),
        ],
      ),
    );
  }
}

class SignUpField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  SignUpField({
    @required this.hintText,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        decoration: InputDecoration(hintText: hintText),
        controller: controller,
      ),
    );
  }
}
