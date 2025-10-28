import 'dart:io';

void main() async {
  final base = 'lib/supabase/sql';
  final files = [
    'schema/01_enums.sql',
    'schema/02_tables.sql',
    'triggers/01_functions.sql',
    'triggers/02_triggers.sql',
    'policies/01_permissions.sql',
    'policies/02_rls_enable.sql',
    'policies/03_rls_policies.sql',
  ];

  final buffer = StringBuffer();

  buffer.writeln(
    "DROP SCHEMA IF EXISTS secret CASCADE; DROP SCHEMA IF EXISTS api CASCADE; CREATE SCHEMA secret; CREATE SCHEMA api;",
  );

  for (final file in files) {
    final path = '$base/$file';
    buffer.writeln('-- $file');
    buffer.writeln(await File(path).readAsString());
    buffer.writeln();
  }

  await File('$base/init.sql').writeAsString(buffer.toString());
}
