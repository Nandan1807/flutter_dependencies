configurations for camera and gallary access

Step 1: Add dependencies in pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^10.2.0
  camera: ^0.10.0+4
  path_provider: ^2.0.10
  image_picker: ^0.8.7+4  # Optional, in case you want an image picker as a fallback.



Permissions Setup for camera and gallary:


For Android, you need to add the following permissions to AndroidManifest.xml:

xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>



For iOS, you need to update the Info.plist file with the following:

xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to capture images.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need access to your photo library to save captured images.</string>

-----------------------------------------------------------------------------------------------------------------
configurations for gallary access

dependencies:
  flutter:
    sdk: flutter
  image_picker: ^0.8.7+4


Permissions Setup for EXTERNAL_STORAGE(gallary):

For Android, add the following permissions in the AndroidManifest.xml:

<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>


For iOS, add the following key to your Info.plist:

<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to pick images.</string>