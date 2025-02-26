# BasiGo Dispatch & Incident Reporting App

A Flutter-based application for reporting and managing incidents, built using Firebase, Riverpod, and Hive for state management and local storage.

## 🚀 Features
- User authentication (Driver & Dispatcher)
- Incident reporting with media attachments
- Offline storage with automatic syncing
- Real-time Firestore updates
- Intuitive UI with animations

## 📂 Project Structure
The application follows the **MVVM (Model-View-ViewModel)** architecture to ensure a clean separation of concerns:
- **Model:** Defines the data structures (e.g., `IncidentModel` in `models/`).
- **View:** UI screens (`view/` and `components/`) handle user interactions and UI logic.
- **ViewModel (Providers):** (`providers/`) manages state and business logic, using Riverpod for dependency injection.
- **Services:** Firebase and local storage services handle database and network communication.

## 📽️ Demo
Here is a demo of the project:
```md
![App Demo](https://github.com/kelvinofula/basigo_incident_app/blob/main/assets/demo.gif)
```
Replace `your-username` and `your-repo` with your actual repository details.

## 🛠️ Installation & Setup
### 1️⃣ Install Flutter
Follow [Flutter installation guide](https://flutter.dev/get-started/install) for your OS.

```sh
flutter doctor
```
If any issues appear, resolve them using the "Commonly Experienced Errors" section below.

### 2️⃣ Clone the Repository
```sh
git clone https://github.com/kelvinofula/basigo_incident_app.git
cd your-repo
```

### 3️⃣ Install Dependencies
Run:
```sh
flutter pub get
```

### 4️⃣ Set Up Firebase
- This project uses my Firebase account so all files are already in the project
- Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- To use your account, set up a project and replace my files with yours.

### 5️⃣ Run the App
```sh
flutter run
```

## 📌 Commonly Experienced Errors & Solutions
### **1️⃣ Flutter directory is not a Git clone**
```sh
flutter doctor
```
**Solution:** Ensure `.git` is copied when extracting the Flutter zip.

### **2️⃣ Android SDK manager not found**
**Solution:** Install/Update to the latestAndroid SDK and ensure that the Command-line tools are installed to resolve this. You can find this in Android Studio → SDK Manager.

### **3️⃣ Pub executables not in PATH**
**Solution:** Add this to `~/.zshrc` or `~/.bashrc`:
```sh
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### **4️⃣ FlutterFire CLI Not Found**
```sh
Activated flutterfire_cli 0.1.1+2.
```
**Solution:** Ensure FlutterFire CLI is in your system PATH by setting it up correctly.

**For zsh on Mac:**
1. Run: `vim ~/.zshrc`
2. Press `i` to enter insert mode
3. Paste: `export PATH="$PATH":"$HOME/.pub-cache/bin"`
4. Press `esc`
5. Type `:wq!` and press `enter`
6. Restart your terminal

### **5️⃣ iOS Build Issues with `permission_handler` and `image_picker`**
When using `permission_handler` and `image_picker`, you need to modify your **Podfile** for iOS compatibility.

#### **Solution:**
1. Open your `ios/Podfile`
2. Add the following inside `post_install do |installer|`:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    ... existing code ...
    # Add these lines:
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
        'PERMISSION_PHOTOS=1',
      ]
    end
  end
end
```

3. Run `pod install` inside the `ios/` directory.
4. Restart your project (`flutter clean && flutter pub get`).

## 📦 Dependencies Explained

### 🏗 **Core Flutter**
```yaml
flutter:
  sdk: flutter
cupertino_icons: ^1.0.8
```
- **flutter**: Core SDK for Flutter development
- **cupertino_icons**: iOS-style icons

### 🔥 **Firebase Services**
```yaml
firebase_core: ^3.12.0
cloud_firestore: ^5.6.4
firebase_messaging: ^15.2.3
firebase_auth: ^5.5.1
```
- **firebase_core**: Initializes Firebase
- **cloud_firestore**: Real-time database
- **firebase_messaging**: Push notifications
- **firebase_auth**: User authentication

### 🎨 **UI & Styling**
```yaml
google_fonts: ^6.2.1
lottie: ^2.7.0
animated_splash_screen: ^1.3.0
```
- **google_fonts**: Custom fonts
- **lottie**: Animated graphics
- **animated_splash_screen**: Splash screen animation

### ⚡ **State Management & Storage**
```yaml
flutter_riverpod: ^2.6.1
hive: ^2.2.3
hive_flutter: ^1.1.0
shared_preferences: ^2.5.2
```
- **flutter_riverpod**: State management
- **hive**: Local database
- **shared_preferences**: Persistent storage

### 📡 **Connectivity & Permissions**
```yaml
connectivity_plus: ^6.1.3
permission_handler: ^11.4.0
```
- **connectivity_plus**: Network detection
- **permission_handler**: Requesting permissions

### 🖼 **Media & Image Handling**
```yaml
image_picker: ^1.1.2
flutter_image_compress: ^2.4.0
```
- **image_picker**: Picking images from gallery/camera
- **flutter_image_compress**: Reducing image size

## 🚀 Contributing
1. Fork the repo
2. Create a new branch (`git checkout -b feature-name`)
3. Commit changes (`git commit -m 'Added feature X'`)
4. Push to branch (`git push origin feature-name`)
5. Open a Pull Request 🎉

## 📜 License
MIT License. See `LICENSE` for details.

---
