import 'package:pocketa/src/features/profile/models/profile.dart';
import 'package:pocketa/src/utils/riverpod/async_notifier_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_service.g.dart';

@Riverpod(keepAlive: true, name: 'profileProvider')
class ProfileService extends _$ProfileService with AsyncNotifierMixin {
  @override
  Future<Profile> build() async {
    return const Profile(
      $id: 'default_id',
      name: 'Bank',
      baseCurrencyCode: 'VES',
      displayCurrencyCode: 'USD',
      $default: true,
    );
  }
}
