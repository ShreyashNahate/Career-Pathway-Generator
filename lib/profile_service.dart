import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isProfileComplete = false;
  bool get isProfileComplete => _isProfileComplete;
  Future<Map<String, dynamic>?> getProfileData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      print('Profile document not found for UID: $uid');
      return null;
    } catch (e) {
      print('Error getting profile data: $e');
      return null;
    }
  }

  Future<void> saveProfileData(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      print('User not authenticated. Cannot save profile.');
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set(data, SetOptions(merge: true));
      print('Profile data saved successfully for UID: $uid');
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }
}
