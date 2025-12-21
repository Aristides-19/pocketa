import 'dart:io';

void main() async {
  const base = 'services/supabase/sql';
  const files = [
    'schema/01_enums.sql',
    'schema/02_tables.sql',
    'triggers/01_functions.sql',
    'triggers/02_triggers.sql',
    'policies/01_permissions.sql',
    'policies/02_rls_enable.sql',
    'policies/03_rls_policies.sql',
    'seed/01_seed_currency.sql',
  ];

  final buffer = StringBuffer();

  buffer.writeln(
    "DROP SCHEMA IF EXISTS secret CASCADE; DROP SCHEMA IF EXISTS api CASCADE; CREATE SCHEMA secret; CREATE SCHEMA api;",
  );

  for (final file in files) {
    buffer
      ..writeln('-- $file')
      ..writeln(await File('$base/$file').readAsString())
      ..writeln();
  }

  await File('$base/init.sql').writeAsString(buffer.toString());
}
