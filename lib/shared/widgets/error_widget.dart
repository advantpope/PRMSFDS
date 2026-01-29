import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final bool showRetry;
  final VoidCallback? onRetry;
  final String? retryText;
  final bool showClose;
  final VoidCallback? onClose;

  const ErrorWidget({
    super.key,
    required this.message,
    this.title = 'Error',
    this.icon,
    this.showRetry = false,
    this.onRetry,
    this.retryText = 'Try Again',
    this.showClose = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),

            // Error Title
            if (title != null)
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

            // Error Message
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showClose)
                  OutlinedButton(
                    onPressed: onClose ?? () => Navigator.maybePop(context),
                    child: const Text('Close'),
                  ),
                if (showClose && showRetry) const SizedBox(width: 12),
                if (showRetry)
                  ElevatedButton(onPressed: onRetry, child: Text(retryText!)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Network Error Widget (specific for network issues)
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool showOfflineOptions;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.showOfflineOptions = false,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      showRetry: true,
      onRetry: onRetry,
      showClose: true,
      retryText: 'Retry',
    );
  }
}

// Empty State Widget (for when there's no data)
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    this.title = 'No Data',
    required this.message,
    this.icon = Icons.inbox,
    this.actionText,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (iconColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: iconColor ?? Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // Message
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Action Button
            if (actionText != null && onAction != null)
              ElevatedButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ),
      ),
    );
  }
}

// Loading Widget
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? size;

  const LoadingWidget({super.key, this.message, this.color, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? Theme.of(context).primaryColor,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Permission Denied Widget
class PermissionDeniedWidget extends StatelessWidget {
  final String permissionType;
  final VoidCallback? onRequestPermission;
  final VoidCallback? onOpenSettings;

  const PermissionDeniedWidget({
    super.key,
    required this.permissionType,
    this.onRequestPermission,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorWidget(
      title: 'Permission Required',
      message: '$permissionType permission is required to use this feature.',
      icon: Icons.privacy_tip,
      showRetry: true,
      onRetry: onRequestPermission,
      retryText: 'Request Permission',
      showClose: true,
      onClose: onOpenSettings,
    );
  }
}

// Custom SnackBar for errors
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}

// Custom Dialog for errors
Future<void> showErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmText,
  VoidCallback? onConfirm,
}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm?.call();
          },
          child: Text(confirmText ?? 'OK'),
        ),
      ],
    ),
  );
}
