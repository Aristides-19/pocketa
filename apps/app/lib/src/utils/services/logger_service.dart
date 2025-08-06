import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_service.g.dart';

@Riverpod(keepAlive: true)
Logger loggerService(Ref ref) {
  return Logger();
}
