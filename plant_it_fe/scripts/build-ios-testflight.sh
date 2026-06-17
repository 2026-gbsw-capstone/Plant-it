#!/bin/bash
set -e

echo "=== Growve iOS TestFlight 빌드 ==="

# Flutter iOS 릴리즈 빌드
flutter build ios --release --no-codesign

echo ""
echo "=== Xcode Archive & Upload ==="

# xcodebuild로 아카이브 생성
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -sdk iphoneos \
  -configuration Release \
  -archivePath build/ios/Growve.xcarchive \
  archive

# TestFlight 업로드
xcodebuild -exportArchive \
  -archivePath build/ios/Growve.xcarchive \
  -exportOptionsPlist ios/ExportOptions/ExportOptions-TestFlight.plist \
  -exportPath build/ios/export

echo ""
echo "=== 완료 ==="
echo "IPA 위치: build/ios/export/Growve.ipa"
echo "App Store Connect에서 TestFlight 빌드를 확인하세요."
