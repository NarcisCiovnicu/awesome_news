import 'package:flutter/material.dart';

import '../view_models/error.viewmodel.dart';

class DisplayErrorWidget extends StatelessWidget {
  final ErrorViewModel errorViewModel;

  const DisplayErrorWidget(this.errorViewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorViewModel.message,
      ),
    );
  }
}
