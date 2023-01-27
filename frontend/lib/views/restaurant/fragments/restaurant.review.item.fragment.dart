import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:foodz/models/review.model.dart';
import 'package:foodz/models/user.model.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/services/review.service.dart';
import 'package:foodz/services/user.service.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/views/restaurant/fragments/restaurant.owner.reply.fragment.dart';
import 'package:foodz/views/restaurant/fragments/restaurant.reply.item.fragment.dart';
import 'package:foodz/views/restaurant/restaurant.review.edit.screen.dart';
import 'package:intl/intl.dart';

class ReviewItemFragment extends StatefulWidget {
  final Review review;
  final Restaurant restaurant;
  ReviewItemFragment(
      {@required this.review, @required this.restaurant, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReviewItemFragmentState();
}

class _ReviewItemFragmentState extends State<ReviewItemFragment> {
  bool _isReplying = false;
  String _reply;

  @override
  void initState() {
    super.initState();
    _reply = widget.review.reply;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => _build(context, constraints));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return IntrinsicHeight(
        child: Column(children: [
      Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_box_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.6,
                              child: FutureBuilder(
                                key: UniqueKey(),
                                future:
                                    UserService().getInfo(widget.review.userId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('Reviewer');
                                  } else {
                                    final User user = snapshot.data;
                                    return Text(
                                        '${user.firstName} ${user.lastName}');
                                  }
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star_rate_rounded,
                                    color: Colors.yellow[600]),
                                Text('${widget.review.rating}',
                                    overflow: TextOverflow.clip)
                              ],
                            ),
                          ],
                        ),
                        Text(
                            '${DateFormat.yMMMMEEEEd().format(widget.review.dateOfVisit)}')
                      ],
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.review.content}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 20,
                          ),
                          if (_isReplying || _reply != null)
                            Divider(
                              thickness: 0.8,
                            ),
                          if (!_isReplying &&
                              _reply == null &&
                              UserSessionService().role == UserRole.OWNER)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () => setState(() {
                                        _isReplying = true;
                                      }),
                                  child: Text('Reply')),
                            ),
                          if (_reply != null) OwnerReplyFragment(reply: _reply),
                          if (_isReplying)
                            ReplyItemFragment(
                                onPost: (value) => _onPostReply(reply: value))
                        ])),
              ],
            ),
            if (UserSessionService().role == UserRole.ADMIN)
              Positioned.fill(
                  child: new Material(
                      color: Colors.transparent,
                      child: new InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantReviewEditScreen(
                                          restaurant: widget.restaurant,
                                          review: widget.review)));
                        },
                      )))
          ],
        ),
      ),
    ]));
  }

  Future<void> _onPostReply({@required String reply}) async {
    await ReviewService().reply(reviewId: widget.review.id, reply: reply);
    setState(() {
      _isReplying = false;
      _reply = reply;
    });
  }
}
