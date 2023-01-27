import 'package:flutter/material.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:foodz/services/review.service.dart';
import 'package:foodz/util/util.dart';
import 'package:intl/intl.dart';

class RestaurantReviewScreen extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantReviewScreen({@required this.restaurant});

  @override
  _RestaurantReviewScreenState createState() => _RestaurantReviewScreenState();
}

class _RestaurantReviewScreenState extends State<RestaurantReviewScreen> {
  double _rating = 3.0;
  DateTime _dateOfVisit = DateTime.now();

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat.yMMMMEEEEd().format(_dateOfVisit);
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
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text('Add a review', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 20),
            Text(
              'How would you rate your visit at ${widget.restaurant.name} located on ${widget.restaurant.address}?',
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
                'When did you visit this location?',
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
                'Tell us about your experience',
                textAlign: TextAlign.center,
              ),
            ),
            TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field cannot be empty.";
                  }
                  return null;
                },
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1),
            SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    child: Text("Post Review"),
                    onPressed: _handlePostReviewAction))
          ]),
        ));
  }

  Future<void> _handlePostReviewAction() async {
    try {
      if (_formKey.currentState != null && _formKey.currentState.validate()) {
        await ReviewService().add(
            restaurantId: widget.restaurant.id,
            content: _contentController.text,
            rating: _rating,
            dateOfVisit: _dateOfVisit);
        Navigator.of(context).pop();
      }
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }
}
