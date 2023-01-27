import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/services/restaurant.service.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/util/util.dart';
import 'package:foodz/views/restaurant/fragments/restaurant.pending.reviews.fragment.dart';
import 'package:foodz/views/restaurant/fragments/restaurant.reviews.fragment.dart';
import 'package:foodz/views/restaurant/restaurant.edit.screen.dart';
import 'package:foodz/views/restaurant/restaurant.review.screen.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantDetailsScreen({@required this.restaurant});

  @override
  State<StatefulWidget> createState() =>
      _RestaurantDetailsScreenState(restaurant: restaurant);
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  int _currentSelection = 1;

  Restaurant restaurant;
  _RestaurantDetailsScreenState({@required this.restaurant});

  @override
  void initState() {
    super.initState();
    _currentSelection = UserSessionService().role == UserRole.OWNER ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: AppBar(
                leading: null,
                flexibleSpace: _buildAppBarImage(context, constraints),
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
              ),
            ),
            body: ConstrainedBox(
                constraints: BoxConstraints(),
                child: _build(context, constraints))));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _buildBasicInfo(context, constraints),
        Divider(),
        if (UserSessionService().role == UserRole.ADMIN)
          _buildAdminControls(context, constraints),
        if (UserSessionService().role == UserRole.OWNER)
          _buildReviewsFilterItem(context),
        Expanded(child: _buildReviewsList(context)),
        if (UserSessionService().role == UserRole.REGULAR)
          _buildReviewButton(context, constraints)
      ]),
    );
  }

  Widget _buildReviewsFilterItem(BuildContext context) {
    Map<int, Widget> _children = {
      0: Text('All Reviews'),
      1: Text('Pending Reviews'),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CupertinoSegmentedControl(
        children: _children,
        borderColor: Theme.of(context).primaryColor,
        pressedColor: Theme.of(context).primaryColor.withOpacity(0.3),
        selectedColor: Theme.of(context).primaryColor,
        unselectedColor: Theme.of(context).canvasColor,
        groupValue: _currentSelection,
        onValueChanged: (value) => {
          setState(() {
            _currentSelection = value;
          })
        },
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context) {
    if (_currentSelection == 0) {
      return RestaurantReviewsFragment(
          key: UniqueKey(),
          restaurant: this.restaurant,
          onUpdateList: () => _getRestaurant(id: this.restaurant.id));
    } else {
      return RestaurantPendingReviewsFragment(
          key: UniqueKey(),
          restaurant: this.restaurant,
          onUpdateList: () => _getRestaurant(id: this.restaurant.id));
    }
  }

  Future<void> _getRestaurant({@required String id}) async {
    try {
      final updatedRestaurant = await RestaurantService().getInfo(id: id);
      setState(() {
        this.restaurant = updatedRestaurant;
      });
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }

  Widget _buildReviewButton(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
          width: constraints.maxWidth,
          child: ElevatedButton(
              child: Text('Add Review'),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => RestaurantReviewScreen(
                            restaurant: this.restaurant)))
                    .then((value) {
                  _getRestaurant(id: this.restaurant.id);
                });
              })),
    );
  }

  Widget _buildBasicInfo(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '${this.restaurant.name}',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.yellow[600]),
                SizedBox(width: 2),
                Text(
                  '${this.restaurant.averageRating.toStringAsFixed(1)}',
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminControls(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              child: ElevatedButton(
                  child: Text('Edit'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantEditScreen(
                                restaurant: this.restaurant)));
                  })),
          SizedBox(width: 10),
          Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: Text('Delete'),
                  onPressed: _handleDeleteAction)),
        ],
      ),
    );
  }

  Future<void> _handleDeleteAction() async {
    try {
      await RestaurantService().delete(restaurantId: this.restaurant.id);
      showSuccessMessage(message: 'Restaurant deleted successfully.');
      Navigator.of(context).pop();
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }

  Widget _buildAppBarImage(BuildContext context, BoxConstraints constraints) {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/business_cover.jpg',
            ),
          ),
        ),
      ),
      Container(
        height: constraints.maxHeight,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.1)
                ],
                stops: [
                  0.0,
                  1.0
                ])),
      )
    ]);
  }
}
