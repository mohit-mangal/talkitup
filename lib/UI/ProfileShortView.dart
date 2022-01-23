import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:talkitup/Models/attendee.dart';
import 'package:talkitup/Models/user_details.dart';
import 'package:talkitup/Providers/user_provider.dart';
import 'package:talkitup/Services/firestore_services.dart';
import 'package:talkitup/UI/loading_widget.dart';

class ProfileShortView extends StatefulWidget {
  static void display(BuildContext context, Attendee summaryUser) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        maxChildSize: 0.7,
        minChildSize: 0.4,
        builder: (_, controller) => ProfileShortView(summaryUser, controller),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  final Attendee summaryUser;
  final ScrollController controller;
  const ProfileShortView(this.summaryUser, this.controller);
  @override
  _ProfileShortViewState createState() => _ProfileShortViewState();
}

class _ProfileShortViewState extends State<ProfileShortView> {
  bool _isMe = false;

  bool _isFetching = true;
  bool _isLoading = false;

  late UserDetails _user;

  Future _fetchUser() async {
    final cuser =
        Provider.of<UserProvider>(context, listen: false).userDetails!;

    if (cuser.id == widget.summaryUser.userId) {
      _isMe = true;
      _user = cuser;
      setState(() {
        _isFetching = false;
      });
      return;
    }

    FirestoreServices.fetchUser(widget.summaryUser.userId).then((value) {
      _user = value!;
      _isFetching = false;

      setState(() {});
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    _fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return LoadingWidget();
    }
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: topSection,
          ),
          Expanded(
            child: ListView(
              controller: widget.controller,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        image: _user.image == null
                            ? null
                            : DecorationImage(
                                image: NetworkImage(_user.image!),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                socialCounts('xXx', 'Friends'),
                                socialCounts('xXx', 'Followers'),
                                socialCounts('xXx', 'Following'),
                              ],
                            ),
                            if (_isMe == false) const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if ((_user.tagline ?? "").isNotEmpty)
                      Row(
                        children: [
                          Container(
                            height: 32,
                            child: const VerticalDivider(
                              thickness: 2,
                              width: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _user.tagline!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    Text(
                      _user.bio ?? "",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get topSection => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            '${_user.username}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.of(context)
              //     .push(MaterialPageRoute(
              //         builder: (_) =>
              //             ProfilePage(userId: widget.summaryUser.userId)))
              //     .then((_) => Navigator.of(context).pop());
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: const Text(
                      'Full Profile',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          )
        ],
      );

  Widget socialCounts(var count, String text) => Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      );
}
