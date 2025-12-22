import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true, name: r'$supabaseClient')
SupabaseClient supabase(Ref ref) {
  return Supabase.instance.client;
}
