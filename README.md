# 🎤 Voice-Powered Task Manager with Gemini AI

A Flutter task management app with **WhatsApp-style voice recording** and **Google Gemini AI** integration for natural language task processing.

## ✨ Features

### 🎯 **Voice Commands with AI**
- **Press & Hold** microphone button to record
- **Natural language processing** with Gemini AI
- **Smart task extraction** from voice input
- **Real-time speech-to-text** conversion

### 📝 **Task Management**
- Create, update, delete tasks via voice
- Set priorities, dates, and descriptions
- Mark tasks as complete/incomplete
- Beautiful, intuitive UI

### 🎨 **Modern UI/UX**
- WhatsApp-style voice recording interface
- Smooth animations and haptic feedback
- Professional design with Material Design 3
- Real-time recording overlay

## 🚀 Quick Start

### 1. **Clone & Setup**
```bash
git clone <repository-url>
cd task_manager_app
flutter pub get
```

### 2. **Get Gemini API Key**
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Copy the key

### 3. **Configure API Key**
Open `lib/core/config/gemini_config.dart` and replace:
```dart
static const String apiKey = 'YOUR_GEMINI_API_KEY_HERE';
```
with your actual API key.

### 4. **Run the App**
```bash
flutter run
```

## 🎤 How to Use Voice Commands

### **Basic Commands**
- **"Create a meeting at 3 PM today"**
- **"Add a task called grocery shopping"**
- **"Delete the meeting task"**
- **"Update meeting to 4 PM"**

### **Advanced Commands**
- **"Create a high priority task for tomorrow"**
- **"Add a task called doctor appointment at 10 AM on Friday"**
- **"Mark grocery shopping as complete"**
- **"Update the meeting description to team sync"**

## 🏗️ Architecture

### **Clean Architecture**
```
lib/
├── core/
│   ├── config/          # Configuration files
│   ├── di/             # Dependency injection
│   └── services/       # External services (Gemini)
├── data/
│   ├── datasources/    # Data sources (local, voice)
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business logic
└── presentation/
    ├── cubits/         # State management
    ├── pages/          # UI pages
    └── widgets/        # Reusable widgets
```

### **Key Components**

#### **Gemini Service** (`lib/core/services/gemini_service.dart`)
- Processes voice commands with AI
- Extracts task information from natural language
- Returns structured JSON responses

#### **Voice Data Source** (`lib/data/datasources/voice_data_source_real.dart`)
- Handles speech-to-text conversion
- Manages microphone permissions
- Integrates with Gemini service

#### **Voice Recording UI** (`lib/presentation/widgets/voice_recording_button.dart`)
- WhatsApp-style press-and-hold interface
- Visual feedback and animations
- Haptic feedback for better UX

## 🔧 Technical Details

### **Dependencies**
```yaml
dependencies:
  flutter_bloc: ^8.1.3          # State management
  google_generative_ai: ^0.2.3  # Gemini AI integration
  speech_to_text: ^6.6.0        # Speech recognition
  permission_handler: ^11.1.0   # Permission management
  get_it: ^7.6.4               # Dependency injection
  equatable: ^2.0.5            # Value equality
```

### **State Management**
- **Bloc/Cubit** for reactive state management
- **Separate state files** for better organization
- **Loading states** for smooth UX

### **Voice Processing Flow**
1. **User presses** microphone button
2. **Speech-to-text** converts voice to text
3. **Gemini AI** processes the text command
4. **Structured data** extracted (action, title, date, etc.)
5. **Task operation** executed based on command

## 🎯 Voice Command Examples

### **Creating Tasks**
```
"Create a meeting at 3 PM today"
"Add a task called grocery shopping"
"Create a high priority task for tomorrow"
"Add doctor appointment at 10 AM on Friday"
```

### **Updating Tasks**
```
"Update meeting to 4 PM"
"Change grocery shopping to tomorrow"
"Update the meeting description"
"Mark task as high priority"
```

### **Deleting Tasks**
```
"Delete the meeting task"
"Remove grocery shopping"
"Cancel the doctor appointment"
```

## 🔒 Permissions

The app requires:
- **Microphone access** for voice recording
- **Internet access** for Gemini AI API calls

## 🐛 Troubleshooting

### **Voice Not Working**
1. Check microphone permissions
2. Ensure internet connection
3. Verify Gemini API key is configured

### **AI Not Responding**
1. Check API key in `gemini_config.dart`
2. Verify internet connection
3. Check API quota limits

### **App Crashes**
1. Run `flutter clean && flutter pub get`
2. Check device compatibility
3. Verify all permissions are granted

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ⚠️ **Web** (Limited voice support)
- ⚠️ **Desktop** (Limited voice support)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **Google Gemini AI** for natural language processing
- **Flutter team** for the amazing framework
- **Speech-to-text plugin** for voice recognition

---

**Made with ❤️ and Flutter**
