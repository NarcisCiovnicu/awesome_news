
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}