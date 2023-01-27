import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodz/constants.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:foodz/models/review.model.dart';
import 'package:foodz/services/review.service.dart';
import 'package:foodz/views/restaurant/fragments/restaurant.review.item.fragment.dart';

class RestaurantReviewsFragment extends StatefulWidget {
  final Restaurant restaurant;
  final Function onUpdateList;

  RestaurantReviewsFragment(
      {@required this.restaurant, this.onUpdateList, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RestaurantReviewsFragmentState();
}

class _RestaurantReviewsFragmentState extends State<RestaurantReviewsFragment> {
  static const _itemsPerPage = 10;
  PagewiseLoadController _pageLoadController;

  @override
  void initState() {
    super.initState();
    _pageLoadController = PagewiseLoadController(
        pageSize: _itemsPerPage, pageFuture: _getReviews);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) =>
            _getAllReviews(context, constraints));
  }

  Widget _getAllReviews(BuildContext context, BoxConstraints constraints) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        _pageLoadController.reset();
        if (widget.onUpdateList != null) {
          widget.onUpdateList();
        }
        await Future.value({});
      },
      child: PagewiseListView(
          key: UniqueKey(),
          shrinkWrap: true,
          pageLoadController: _pageLoadController,
          itemBuilder: (context, item, itemIndex) {
            final RestaurantReviewItemWrapper itemWrapper = item;
            final reviewItem = ReviewItemFragment(
              review: itemWrapper.review,
              restaurant: widget.restaurant,
            );

            if (itemWrapper.type == RestaurantReviewItemType.ItemWithTitle) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(itemWrapper.title,
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                  reviewItem
                ],
              );
            } else {
              return reviewItem;
            }
          },
          loadingBuilder: (context) => CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              backgroundColor: Theme.of(context).primaryColor),
          noItemsFoundBuilder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Looks like there are no reviews yet!',
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
          }),
    );
  }

  Future<List<RestaurantReviewItemWrapper>> _getReviews(int pageNumber) async {
    final reviewsWithHighlights = await ReviewService().getAllWithHighlights(
        restaurantId: widget.restaurant.id,
        pageNumber: pageNumber,
        itemsPerPage: _itemsPerPage);

    final mapReview = (idx, review, title) {
      return (pageNumber == 0 && idx == 0)
          ? RestaurantReviewItemWrapper.itemWithTitle(
              review: review, title: title)
          : RestaurantReviewItemWrapper.simpleItem(review: review);
    };

    final highlights = reviewsWithHighlights.highlights
        .asMap()
        .entries
        .map((e) => mapReview(e.key, e.value, 'Review Highlights'));
    final reviews = reviewsWithHighlights.reviews
        .asMap()
        .entries
        .map((e) => mapReview(e.key, e.value, 'All Reviews'));

    return [...highlights, ...reviews];
  }
}

enum RestaurantReviewItemType { SimpleItem, ItemWithTitle }

class RestaurantReviewItemWrapper {
  final RestaurantReviewItemType type;
  final String title;
  final Review review;

  RestaurantReviewItemWrapper.itemWithTitle(
      {@required this.review, @required this.title})
      : type = RestaurantReviewItemType.ItemWithTitle;
  RestaurantReviewItemWrapper.simpleItem({@required this.review})
      : type = RestaurantReviewItemType.SimpleItem,
        title = null;
}
