import 'package:flutter/material.dart';
import 'package:pocketa/src/constants/constants.dart';
import 'package:pocketa/src/router/keys.dart';
import 'package:pocketa/src/utils/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toastification/toastification.dart';

part 'toaster_provider.g.dart';

class Toaster {
  const Toaster();

  void add(
    ToasterMode mode,
    String subject,
    String body, {
    int duration = 5,
    bool dismissAll = false,
  }) {
    final theme = Theme.of(rootNavigatorKey.currentContext!);
    if (dismissAll) toastification.dismissAll();
    toastification.show(
      type: mode.toToastificationType,
      style: ToastificationStyle.flat,
      title: Text(subject, style: theme.textTheme.titleMedium),
      description: Text(body, style: theme.textTheme.bodyMedium),
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      alignment: Alignment.topCenter,
      autoCloseDuration: Duration(seconds: duration),
      borderRadius: AppTheme.borderRadius,
      dragToClose: true,
      pauseOnHover: true,
    );
  }

  void showException(Exception e, {int duration = 5, bool dismissAll = false}) {
    if (e is! AppException) {
      add(
        ToasterMode.error,
        'Error',
        e.toString(),
        duration: duration,
        dismissAll: dismissAll,
      );
      return;
    }
    add(
      ToasterMode.error,
      e.title(),
      e.message(),
      duration: duration,
      dismissAll: dismissAll,
    );
  }
}

@Riverpod(keepAlive: true, name: r'$toastService')
Toaster toast(Ref ref) {
  return const Toaster();
}

enum ToasterMode { info, success, warning, error }

extension ToasterModeExt on ToasterMode {
  ToastificationType get toToastificationType {
    switch (this) {
      case ToasterMode.info:
        return ToastificationType.info;
      case ToasterMode.success:
        return ToastificationType.success;
      case ToasterMode.warning:
        return ToastificationType.warning;
      case ToasterMode.error:
        return ToastificationType.error;
    }
  }
}
