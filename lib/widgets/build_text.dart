import 'package:flutter/cupertino.dart';

Widget buildRichText(String label, String value) {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: '$label: ',
          style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w500),
        ),
        TextSpan(
          text: value,
          style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w300),
        ),
      ],
    ),
  );
}
