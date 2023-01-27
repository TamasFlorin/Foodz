import 'package:flutter/material.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:foodz/models/review.model.dart';
import 'package:foodz/services/review.service.dart';
import 'package:foodz/util/util.dart';
import 'package:intl/intl.dart';

class RestaurantReviewEditScreen extends StatefulWidget {
  final Restaurant restaurant;
  final Review review;
  RestaurantReviewEditScreen(
      {@required this.restaurant, @required this.review});

  @override
  _RestaurantReviewEditScreenState createState() =>
      _RestaurantReviewEditScreenState();
}

class _RestaurantReviewEditScreenState
    extends State<RestaurantReviewEditScreen> {
  double _rating = 1.0;
  DateTime _dateOfVisit = DateTime.now();

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dateController.text =
        DateFormat.yMMMMEEEEd().format(widget.review.dateOfVisit);
    _contentController.text = widget.review.content;
    _replyController.text = widget.review.reply;
    _rating = widget.review.rating;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(child: _build(context, constraints))));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return Padding(
        padding: EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text('Edit review', style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 20),
          Text(
            'Review for visit at ${widget.restaurant.name} located on ${widget.restaurant.address}',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemBuilder: (context, _) => Icon(
              Icons.star_rounded,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _rating = rating;
            },
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Date of the visit',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: constraints.maxWidth,
            child: TextFormField(
              controller: _dateController,
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                DatePicker.showDatePicker(context,
                    maxTime: DateTime.now(),
                    currentTime: _dateOfVisit, onConfirm: (date) {
                  setState(() {
                    _dateOfVisit = date;
                    _dateController.text =
                        DateFormat.yMMMMEEEEd().format(_dateOfVisit);
                  });
                });
              },
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            child: Text(
              'User experience at this location',
              textAlign: TextAlign.center,
            ),
          ),
          TextFormField(
              controller: _contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1),
          SizedBox(height: 20),
          SizedBox(
            child: Text(
              'Owner reply',
              textAlign: TextAlign.center,
            ),
          ),
          TextFormField(
              controller: _replyController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1),
          SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  child: Text("Save"), onPressed: _handleSaveAction)),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: Text("Delete"),
                  onPressed: _handleDeleteAction))
        ]));
  }

  Future<void> _handleSaveAction() async {
    try {
      await ReviewService().update(
          reviewId: widget.review.id,
          content: _contentController.text,
          reply: _replyController.text.isEmpty ? null : _replyController.text,
          rating: _rating,
          dateOfVisit: _dateOfVisit);
      Navigator.of(context).pop();
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }

  Future<void> _handleDeleteAction() async {
    try {
      await ReviewService().delete(reviewId: widget.review.id);
      Navigator.of(context).pop();
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }
}
