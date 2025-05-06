import 'package:flutter/material.dart';

class ConfirmationMessage extends StatelessWidget {
  final String title;
  final String? description;
  final String yesText;
  final String noText;
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  const ConfirmationMessage({
    Key? key,
    required this.title,
    this.description,
    this.yesText = "Yes",
    this.noText = "No",
    required this.onYesPressed,
    required this.onNoPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              if (description != null) ...[
                const SizedBox(height: 10),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onNoPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    ),
                    child: Text(noText, style: const TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: onYesPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    ),
                    child: Text(yesText, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
