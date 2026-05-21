class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://bncnqdpiefocyzqurlsj.supabase.co',
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuY25xZHBpZWZvY3l6cXVybHNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcyNzM3ODUsImV4cCI6MjA5Mjg0OTc4NX0.'
        'OGLrdEOOrXeu0vs6y3ntXaFgDX7EmeYwPH9F3XBsh08',
  );
}
