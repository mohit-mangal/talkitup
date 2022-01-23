import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanoid/nanoid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:talkitup/Models/attendee.dart';
import 'package:talkitup/Models/comment.dart';
import 'package:talkitup/Models/room.dart';
import 'package:talkitup/Models/user_details.dart';

class FirestoreServices {
  static final _firestore = FirebaseFirestore.instance;

  static const roomCollectionName = 'Rooms';
  static const userCollectionName = 'Users';
  static const commentCollectionName = 'Comments';
  static const attendeeCollectionName = 'Attendee';

  static Future<String> _uploadImageToFirestore(
    MemoryImage memoryImage,
    String imageName,
  ) async {
    final storageRef = FirebaseStorage.instance.ref(imageName);
    final uploadTask = storageRef.putData(memoryImage.bytes);

    return await uploadTask.then((val) async => await val.ref.getDownloadURL(),
        onError: (err) {
      print('image could not be uploaded : $err');
    });
  }

  static Future<void> _deleteImageFromFirestore(String imageUrl) async {
    if (imageUrl == null) return;
    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (e) {
      print('image could not be deleted: ${e.toString()}');
    }
  }

  static Future<bool> saveUser(
      UserDetails userDetails, MemoryImage? image) async {
    try {
      await _firestore
          .collection(userCollectionName)
          .doc(userDetails.id)
          .set(jsonDecode(userDetails.toJson()));
      if (image != null) {
        try {
          final url = await _uploadImageToFirestore(image, userDetails.id);
          await _firestore
              .collection(userCollectionName)
              .doc(userDetails.id)
              .update({'image': url});
        } catch (e) {
          // TODO: show toast
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<UserDetails?> fetchUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreServices.userCollectionName)
          .doc(userId)
          .get();
      final val = UserDetails.fromJson(jsonEncode(doc.data()));
      return val;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveRoom(Room room, MemoryImage? image,
      {bool update = false}) async {
    try {
      final docRef = _firestore.collection(roomCollectionName).doc(room.id);
      if (update) {
        await docRef.update(jsonDecode(room.toJson()));
      } else {
        await docRef.set(jsonDecode(room.toJson()));
      }
      if (image != null) {
        try {
          final url = await _uploadImageToFirestore(image, nanoid());
          await _firestore
              .collection(roomCollectionName)
              .doc(room.id)
              .update({'image': url});
        } catch (e) {
          // TODO: show toast
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveAttendee(Attendee attendee, String roomId,
      {bool update = false}) async {
    try {
      final docRef = _firestore
          .collection(roomCollectionName)
          .doc(roomId)
          .collection(attendeeCollectionName)
          .doc(attendee.userId);
      if (update) {
        await docRef.update(jsonDecode(attendee.toJson()));
      } else {
        await docRef.set(jsonDecode(attendee.toJson()));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteAttendee(String userId, String roomId) async {
    try {
      await _firestore
          .collection(roomCollectionName)
          .doc(roomId)
          .collection(attendeeCollectionName)
          .doc(userId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<QuerySnapshot> get roomStream => _firestore
      .collection(roomCollectionName)
      .where('status', isNotEqualTo: 'FINISHED')
      .orderBy('status')
      .snapshots();

  static Stream<QuerySnapshot> attendeeStream(String roomId) => _firestore
      .collection(roomCollectionName)
      .doc(roomId)
      .collection(attendeeCollectionName)
      .orderBy('isSpeaker', descending: true)
      .snapshots();

  static Future<List<Attendee>> fetchAttendee(String roomId) async =>
      (await _firestore
              .collection(roomCollectionName)
              .doc(roomId)
              .collection(attendeeCollectionName)
              .get())
          .docs
          .map((snapshot) => snapshot.data())
          .map((data) => Attendee.fromJson(jsonEncode(data))!)
          .toList();

  static Future<bool> addNewComment(Comment comment, String roomId) async {
    try {
      await _firestore
          .collection(roomCollectionName)
          .doc(roomId)
          .collection(commentCollectionName)
          .add(jsonDecode(comment.toJson()));
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
      return false;
    }
  }

  static Stream<QuerySnapshot> commentStream(String roomId) => _firestore
      .collection(roomCollectionName)
      .doc(roomId)
      .collection(commentCollectionName)
      .orderBy('timestamp', descending: true)
      .snapshots();
}
