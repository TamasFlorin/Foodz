import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodz/services/restaurant.service.dart';
import 'package:foodz/views/home/home.screen.dart';

import '../../constants.dart';

class RestaurantClaimScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RestaurantClaimScreenState();
}

class RestaurantClaimScreenState extends State<RestaurantClaimScreen> {
  final _businessNameTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _businessFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => _build(context, constraints));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
              child: _buildForm(context, constraints),
              padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.04,
                  right: constraints.maxWidth * 0.04,
                  top: constraints.maxHeight * 0.1)),
        ));
  }

  Widget _buildForm(BuildContext context, BoxConstraints constraints) {
    return Column(children: [
      Text("Claim your business", style: Theme.of(context).textTheme.headline6),
      SizedBox(height: 0.03 * constraints.maxHeight),
      _buildIllustration(context, constraints),
      SizedBox(height: 0.03 * constraints.maxHeight),
      _buildFields(context, constraints),
    ]);
  }

  Widget _buildIllustration(BuildContext context, BoxConstraints constraints) {
    return Container(
        height: 0.25 * constraints.maxHeight,
        child: SvgPicture.asset(
          BUSINESS_ILLUSTRATION_ASSET,
          semanticsLabel: 'Business owner visualization',
          alignment: Alignment.topCenter,
        ));
  }

  Widget _buildFields(BuildContext context, BoxConstraints constraints) {
    return Form(
        key: _businessFormKey,
        child: Column(children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Business Name'),
            controller: _businessNameTextController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty.';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Business Address'),
            controller: _addressTextController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty.';
              }
              return null;
            },
          ),
          SizedBox(height: 0.02 * constraints.maxHeight),
          Text.rich(
            TextSpan(
              text:
                  'By continuing with this information, you confirm that you have the authority to claim this business, and agree to our ',
              children: <TextSpan>[
                TextSpan(
                    text: 'Terms of Use',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    )),
                TextSpan(text: ' and '),
                TextSpan(
                    text: 'Privacy Policy.',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    )),
              ],
            ),
          ),
          SizedBox(height: 0.02 * constraints.maxHeight),
          Container(
              width: constraints.maxWidth,
              child: ElevatedButton(
                  child: Text("Continue"),
                  onPressed: () async {
                    if (_businessFormKey.currentState != null &&
                        _businessFormKey.currentState.validate()) {
                      final _ = await RestaurantService().create(
                          name: _businessNameTextController.text,
                          address: _addressTextController.text);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (_) => false);
                    }
                  }))
        ]));
  }
}
