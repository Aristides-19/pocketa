import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketa/src/features/auth/auth.dart';
import 'package:pocketa/src/widgets/widgets.dart';

class AuthInfo extends ConsumerWidget {
  const AuthInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch($authStreamQuery);
    final theme = Theme.of(context);

    /// Normally, this screen should not be displayed if the user is not authenticated.
    /// If so, the router should redirect to the login screen.
    /// However, it's better to check to get type safety on provider value.
    return auth.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const ErrorScreen(),
      data: (auth) => Column(
        children: [
          SizedBox(
            width: 84,
            child: BoringAvatar(
              name: auth.user?.$id ?? '',
              type: .beam,
              shape: OvalBorder(
                side: BorderSide(width: 2, color: theme.colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(auth.user?.name ?? '', style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            auth.user?.email ?? '',
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}
