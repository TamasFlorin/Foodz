import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:foodz/services/restaurant.service.dart';
import 'package:foodz/util/util.dart';

import '../../constants.dart';

class RestaurantEditScreen extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantEditScreen({@required this.restaurant});

  @override
  State<StatefulWidget> createState() => RestaurantEditScreenState();
}

class RestaurantEditScreenState extends State<RestaurantEditScreen> {
  final _businessNameTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _businessFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _businessNameTextController.text = widget.restaurant.name;
    _addressTextController.text = widget.restaurant.address;
  }

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
      Text("Business Details", style: Theme.of(context).textTheme.headline6),
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
            decoration: InputDecoration(hintText: 'Business Name...'),
            controller: _businessNameTextController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty.';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Business Address...'),
            controller: _addressTextController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty.';
              }
              return null;
            },
          ),
          SizedBox(height: 0.02 * constraints.maxHeight),
          Container(
              width: constraints.maxWidth,
              child: ElevatedButton(
                  child: Text("Save"), onPressed: _handleSaveAction))
        ]));
  }

  Future<void> _handleSaveAction() async {
    try {
      if (_businessFormKey.currentState != null &&
          _businessFormKey.currentState.validate()) {
        final _ = await RestaurantService().update(
            restaurantId: widget.restaurant.id,
            name: _businessNameTextController.text,
            address: _addressTextController.text);
        Navigator.pop(context);
      }
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }
}
