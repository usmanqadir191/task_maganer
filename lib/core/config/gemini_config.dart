class GeminiConfig {
  static const String apiKey = 'AIzaSyDWHfjCyHdkNt_NtIBvjW310f0UfAlQM_0';
  
  static bool get isConfigured => apiKey != 'AIzaSyDWHfjCyHdkNt_NtIBvjW310f0UfAlQM_0' && apiKey.isNotEmpty;
  
  static String get errorMessage {
    if (!isConfigured) {
      return '''
⚠️ Gemini API Key Not Configured

To use voice commands with AI, you need to:

1. Get a Gemini API key from:
   https://makersuite.google.com/app/apikey

2. Replace 'YOUR_GEMINI_API_KEY_HERE' in:
   lib/core/config/gemini_config.dart

3. Restart the app

The app will work without AI, but voice commands will be limited.
''';
    }
    return '';
  }
} 