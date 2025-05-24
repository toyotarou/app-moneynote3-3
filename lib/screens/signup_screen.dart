import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../extensions/extensions.dart';
import 'components/parts/custom_shape_clipper.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: context.screenSize.height * 0.9,
              width: context.screenSize.width * 0.9,
              margin: const EdgeInsets.only(top: 5, left: 6),
              color: const Color(0xFFFBB6CE).withOpacity(0.6),
              child: Text('■', style: TextStyle(color: Colors.white.withOpacity(0.1))),
            ),
          ),
          Container(
            width: context.screenSize.width,
            height: context.screenSize.height,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(width: context.screenSize.width),
                const SizedBox(height: 60),
                Container(
                  width: context.screenSize.width / 2.5,
                  height: 140,
                  decoration:
                      const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/coinpig.png'))),
                ),
                Container(
                  width: context.screenSize.width / 2.5,
                  height: 30,
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/moneynote_title.png'))),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        // ignore: inference_failure_on_instance_creation, always_specify_types
                        MaterialPageRoute(builder: (BuildContext context) => LoginScreen(isar: widget.isar)));
                  },
                  child: const Text('SIGN UP'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        // ignore: inference_failure_on_instance_creation, always_specify_types
                        MaterialPageRoute(builder: (BuildContext context) => LoginScreen(isar: widget.isar)));
                  },
                  child: const Text('LOGIN'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
