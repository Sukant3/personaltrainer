import 'package:flutter/material.dart';

class TransferDeviceRequestScreen extends StatelessWidget {
  const TransferDeviceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Transfer Request"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sync_alt_rounded, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                "A transfer request has been sent to the previously linked user. Please wait for approval.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text("Go Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
