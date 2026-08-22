import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';

class ReceiptPreviewDialog extends StatelessWidget {
  final String imageUrl;

  const ReceiptPreviewDialog({super.key, required this.imageUrl});

  static Future<void> show(BuildContext context, {required String imageUrl}) {
    return showDialog(
      context: context,
      builder: (_) => ReceiptPreviewDialog(imageUrl: imageUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Text(AppStrings.adminReceiptImageTitle),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          AppNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            height: 350.h,
          ),
        ],
      ),
    );
  }
}
