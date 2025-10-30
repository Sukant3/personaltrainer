import 'package:flutter/material.dart';

class DeviceAlreadyLinkedScreen extends StatelessWidget {
  const DeviceAlreadyLinkedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Already Linked"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text(
                "This device is already linked with another account.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text("Try Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
