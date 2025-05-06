import 'package:flutter/material.dart';

class SuccessMessage extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onOkPressed;

  const SuccessMessage({
    Key? key,
    required this.title,
    this.description,
    required this.onOkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MessageCard(
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      title: title,
      description: description,
      onOkPressed: onOkPressed,
    );
  }
}

class FailureMessage extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onOkPressed;

  const FailureMessage({
    Key? key,
    required this.title,
    this.description,
    required this.onOkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MessageCard(
      icon: Icons.highlight_off,
      iconColor: Colors.red,
      title: title,
      description: description,
      onOkPressed: onOkPressed,
    );
  }
}

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? description;
  final VoidCallback onOkPressed;

  const _MessageCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.description,
    required this.onOkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 80, color: iconColor),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
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
              ElevatedButton(
                onPressed: onOkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("OK", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
