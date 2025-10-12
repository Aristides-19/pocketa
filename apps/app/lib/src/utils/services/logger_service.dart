import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_service.g.dart';

@Riverpod(keepAlive: true)
Logger logger(Ref ref) {
  return Logger();
}
