import 'package:flutter/material.dart';

class OwnerReplyFragment extends StatefulWidget {
  final String reply;
  OwnerReplyFragment({@required this.reply});

  @override
  State<StatefulWidget> createState() => OwnerReplyFragmentState();
}

class OwnerReplyFragmentState extends State<OwnerReplyFragment> {
  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  width: 2.0, color: Theme.of(context).primaryColor))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_box_rounded, size: 40),
              Text(
                'Owner',
                textAlign: TextAlign.start,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text('${widget.reply}', maxLines: null),
          ),
        ],
      ),
    );
  }
}
