import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';

class UrlLauncherHelper {
  UrlLauncherHelper._();

  /// Clean phone string to contain only digits and optional leading '+'
  static String cleanPhoneNumber(String phone) {
    var cleaned = phone.trim().replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('01')) {
      // Convert Egyptian 01x local number to international format +201x
      cleaned = '+20${cleaned.substring(1)}';
    } else if (!cleaned.startsWith('+') && cleaned.startsWith('20')) {
      cleaned = '+$cleaned';
    }
    return cleaned;
  }

  /// Launch WhatsApp with custom message
  static Future<void> launchWhatsApp({
    required BuildContext context,
    required String phone,
    String? message,
  }) async {
    final cleaned = cleanPhoneNumber(phone);
    final text = Uri.encodeComponent(
      message ?? 'السلام عليكم، أود الاستفسار عن رحلاتكم في تطبيق فسحة.',
    );

    final String cleanDigits = cleaned.replaceAll('+', '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanDigits?text=$text');
    final Uri fallbackUri =
        Uri.parse('whatsapp://send?phone=$cleanDigits&text=$text');

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          AppSnackbar.showError(
            context: context,
            message: 'تطبيق WhatsApp غير مثبت على هذا الجهاز',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.showError(
          context: context,
          message: 'تعذر فتح WhatsApp: $e',
        );
      }
    }
  }

  /// Make a direct phone call
  static Future<void> makePhoneCall({
    required BuildContext context,
    required String phone,
  }) async {
    final cleaned = cleanPhoneNumber(phone);
    final Uri phoneUri = Uri.parse('tel:$cleaned');

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          AppSnackbar.showError(
            context: context,
            message: 'تعذر إجراء الاتصال الهاتفي على هذا الجهاز',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.showError(
          context: context,
          message: 'حدث خطأ أثناء إجراء الاتصال: $e',
        );
      }
    }
  }

  /// Show Contact Bottom Sheet choice (WhatsApp vs Call)
  static void showContactOptionsModal({
    required BuildContext context,
    required String phone,
    required String title,
    String? initialMessage,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF25D366),
                  child: Icon(Icons.chat, color: Colors.white),
                ),
                title: const Text(
                  'تواصل عبر WhatsApp',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(phone),
                onTap: () {
                  Navigator.pop(modalContext);
                  launchWhatsApp(
                    context: context,
                    phone: phone,
                    message: initialMessage,
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.phone, color: Colors.white),
                ),
                title: const Text(
                  'إجراء اتصال هاتفي',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(phone),
                onTap: () {
                  Navigator.pop(modalContext);
                  makePhoneCall(
                    context: context,
                    phone: phone,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
