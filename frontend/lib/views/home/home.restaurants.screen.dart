import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodz/constants.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/services/restaurant.service.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/util/value.range.dart';
import 'package:foodz/views/home/fragments/home.restaurant.item.fragment.dart';
import 'fragments/home.create.business.fragment.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  static const _itemsPerPage = 3;
  PagewiseLoadController _pageLoadController;
  RangeValues _ratingRangeValues = const RangeValues(0.0, 5.0);

  @override
  void initState() {
    super.initState();
    _pageLoadController = PagewiseLoadController(
        pageSize: _itemsPerPage, pageFuture: _getRestaurants);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
            body: SafeArea(
                child: Padding(
                    child: _build(context, constraints),
                    padding: EdgeInsets.only(
                        left: 0.03 * constraints.maxWidth,
                        right: 0.03 * constraints.maxWidth)))));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        this._pageLoadController.reset();
        await Future.value({});
      },
      child: ListView(
        shrinkWrap: true,
        children: [
          ListView(
            shrinkWrap: true,
            children: _buildListTitleItems(context),
            physics: NeverScrollableScrollPhysics(),
          ),
          _buildRestaurantsList(context, constraints),
        ],
      ),
    );
  }

  List<Widget> _buildListTitleItems(BuildContext context) {
    return [
      if (UserSessionService().role == UserRole.OWNER) CreateBusinessItem(),
      Padding(
          child: ExpansionTile(
              maintainState: true,
              tilePadding: EdgeInsets.zero,
              title: Text("All Restaurants",
                  style: Theme.of(context).textTheme.headline6),
              children: [_buildRatingFilter(context)]),
          padding: EdgeInsets.all(4.0))
    ];
  }

  Widget _buildRestaurantsList(
      BuildContext context, BoxConstraints constraints) {
    return PagewiseListView(
        pageLoadController: _pageLoadController,
        //physics: AlwaysScrollableScrollPhysics(),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, item, itemIndex) {
          final restaurantItem = RestaurantItem(restaurant: item);
          return restaurantItem;
        },
        loadingBuilder: (context) => CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            backgroundColor: Theme.of(context).primaryColor),
        noItemsFoundBuilder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Oops! Looks like there are no restaurants for this query!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(height: 30),
              SvgPicture.asset(
                BLANK_CANVAS_ILLUSTRATION_ASSET,
                fit: BoxFit.fitWidth,
                width: 0.5 * constraints.maxWidth,
                height: 0.5 * constraints.maxHeight,
              ),
            ],
          );
        });
  }

  Widget _buildRatingFilter(BuildContext context) {
    return Column(
      children: [
        Text("Filter by rating", style: Theme.of(context).textTheme.subtitle1),
        RangeSlider(
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
            values: _ratingRangeValues,
            divisions: 5 ~/ 0.5,
            min: 0.0,
            max: 5.0,
            labels: RangeLabels(
              '${_ratingRangeValues.start} stars',
              '${_ratingRangeValues.end} stars',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _ratingRangeValues = values;
                _pageLoadController.reset();
              });
            }),
      ],
    );
  }

  Future<List<Restaurant>> _getRestaurants(int pageNumber) async {
    return RestaurantService().getAll(
        pageNumber: pageNumber,
        itemsPerPage: _itemsPerPage,
        ratingRange: ValueRange<double>(
            min: _ratingRangeValues.start, max: _ratingRangeValues.end),
        ownerId: UserSessionService().role == UserRole.OWNER
            ? UserSessionService().userId
            : null);
  }
}
