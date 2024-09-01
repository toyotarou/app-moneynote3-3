import 'package:flutter/material.dart';

import '../../../extensions/extensions.dart';

class BackGroundImage extends StatelessWidget {
  const BackGroundImage({super.key});

  ///
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 0,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: context.screenSize.width / 2.5,
                height: 140,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/coinpig.png'))),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: context.screenSize.width / 2.5,
                    height: 30,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/moneynote_title.png'))),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
