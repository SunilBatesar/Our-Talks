// username_checker.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsernameChecker extends StatelessWidget {
  final String username;
  final RxBool isUserNameAvailable;

  const UsernameChecker(
      {super.key, required this.username, required this.isUserNameAvailable});

  @override
  Widget build(BuildContext context) {
    if (username.isEmpty) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('userName', isEqualTo: username)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            "Checking...",
            style: TextStyle(color: Colors.blue),
          );
        }

        if (snapshot.hasError) {
          return const Text(
            "Error checking username",
            style: TextStyle(color: Colors.red),
          );
        }

        final isAvailable = snapshot.data!.docs.isEmpty;
        isUserNameAvailable.value = isAvailable;

        return Align(
          alignment: Alignment.centerRight,
          child: Text(
            isAvailable ? "Username available" : "Username not available",
            style: TextStyle(color: isAvailable ? Colors.green : Colors.red),
          ),
        );
      },
    );
  }
}
