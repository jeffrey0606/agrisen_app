import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HasNotLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //height: MediaQuery.of(context).size.height * .5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'LOGIN INTO AGRISENSOR WITH',
              style: TextStyle(
                color: Color.fromRGBO(10, 17, 40, 1.0),
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            FloatingActionButton.extended(
              label: Text(
                'google',
                style: TextStyle(
                  color: Color.fromRGBO(10, 17, 40, 1.0),
                  fontSize: 18,
                ),
              ),
              icon: SvgPicture.asset(
                'assets/SVGPics/google.svg',
                height: 30,
              ),
              onPressed: () {},
            ),
            Text(
              'OR',
              style: TextStyle(
                color: Color.fromRGBO(10, 17, 40, 1.0),
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            FloatingActionButton.extended(
              label: Text(
                'facebook',
                style: TextStyle(
                  color: Color.fromRGBO(10, 17, 40, 1.0),
                  fontSize: 18,
                ),
              ),
              icon: SvgPicture.asset(
                'assets/SVGPics/facebook.svg',
                height: 30,
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
