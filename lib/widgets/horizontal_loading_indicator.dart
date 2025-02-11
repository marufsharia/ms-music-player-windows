// lib/ui/widgets/horizontal_loading_indicator.dart
import 'package:flutter/material.dart';

class HorizontalLoadingIndicator extends StatelessWidget {
  final String text;

  const HorizontalLoadingIndicator({Key? key, this.text = 'Loading...'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LinearProgressIndicator(), // Horizontal progress bar
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}