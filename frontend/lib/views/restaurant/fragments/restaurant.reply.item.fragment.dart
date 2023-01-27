import 'package:flutter/material.dart';

class ReplyItemFragment extends StatefulWidget {
  final Function(String reply) onPost;
  ReplyItemFragment({this.onPost});

  @override
  State<StatefulWidget> createState() => _ReplyItemFragmentState();
}

class _ReplyItemFragmentState extends State<ReplyItemFragment> {
  final _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            controller: _replyController,
            textInputAction: TextInputAction.done,
            maxLines: null,
            decoration: InputDecoration(hintText: 'Leave a reply....')),
        Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: () => widget.onPost(_replyController.text),
                child: Text('Post')))
      ],
    );
  }
}
