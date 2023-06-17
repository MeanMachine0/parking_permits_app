# parking_permits_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Tim's mac notes 
proxy_off
Use command line for flutter pub get, git push and flutter run --release to avoid proxy issues 

First time only after cloning so doesn't use default public email address
git config --local user.email "2013064+timjcarter@users.noreply.github.com" 

After fresh clone need to generate files which are ignored by git using these commands:
tcarter parking_permits_app % firebase login
Already logged in as tim.carter.home@gmail.com
tcarter parking_permits_app % flutterfire configure

### To build and install on a real iPhone/iPad
Having trouble with FAD, use these steps:
1. connect iPhone/iPad to dev mac with cable
2. launch compatible xCode - need newer version for latest iOS
3. wait for phone to be ready for development (e.g. deownload symbols)

flutter run --release

### To build for Firebase App Distribution
Some useful info at https://docs.flutter.dev/deployment/ios

flutter build ipa --export-method development

Got this error:
2023-06-17 15:14:47.445 upload-symbols[28724:13884692] Unable to get file attributes for dSYM file at path
    "/Users/tcarter/Library/Developer/Xcode/DerivedData/Runner-cnnfldhcakzsvdfgjzrnfqslmdrx/Build/Intermediates.noindex/ArchiveIntermediates/Runner/B
    uildProductsPath/Release-iphoneos/App.framework.dSYM/Contents/Resources/DWARF"

Workaround of commenting out the upload-symbols command in "Crashlytics Upload Symbols" Build Phase

OUTPUT after workaround:
tcarter@R4PMH25R74 parking_permits_app % flutter build ipa --export-method development

💪 Building with sound null safety 💪

Archiving com.MeanMachine0.ParkingPermitsApp...
Automatically signing iOS for device deployment using specified development team in Xcode project: 46U6J9N8V3
Running Xcode build...                                                  
 └─Compiling, linking and signing...                         4.2s
Xcode archive done.                                         29.8s
Built /Users/tcarter/Development/FlutterProjects/parking_permits_app/build/ios/archive/Runner.xcarchive.
Building development IPA...                                         9.6s
Built IPA to /Users/tcarter/Development/FlutterProjects/parking_permits_app/build/ios/ipa.
tcarter@R4PMH25R74 parking_permits_app % 

