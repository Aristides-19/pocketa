import 'package:pocketa/src/utils/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO Add locale titles and messages
class AccountLimitException extends AppPGException {
  const AccountLimitException();
  @override
  bool matches(PostgrestException e) => e.code == 'AC010';
  @override
  String title() => '';
  @override
  String message() => '';
}

class CurrencyUpdateException extends AppPGException {
  const CurrencyUpdateException();
  @override
  bool matches(PostgrestException e) => e.code == 'AC001';
  @override
  String title() => '';
  @override
  String message() => '';
}
