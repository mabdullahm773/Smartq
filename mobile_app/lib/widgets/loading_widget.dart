import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // User can't dismiss by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/loading.json',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context); // This will close the top-most dialog
}

