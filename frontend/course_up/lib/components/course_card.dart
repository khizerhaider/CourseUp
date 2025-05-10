import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String thumbnailBase64;

  const CourseCard({
    super.key,
    required this.title,
    required this.thumbnailBase64,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;

    try {
      final String cleanBase64 = thumbnailBase64.split(',').last;
      imageBytes = base64Decode(cleanBase64);
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child:
                imageBytes != null
                    ? Image.memory(
                      imageBytes,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : const Placeholder(
                      fallbackHeight: 100,
                      fallbackWidth: double.infinity,
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
