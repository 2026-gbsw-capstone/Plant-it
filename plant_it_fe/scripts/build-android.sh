#!/bin/bash
set -e

echo "=== Growve Android APK 빌드 ==="

# ABI별 분할 APK 빌드 (arm64-v8a가 현재 기기 대부분)
flutter build apk --release --split-per-abi

echo ""
echo "=== 빌드 완료 ==="
echo "APK 위치:"
ls -lh build/app/outputs/flutter-apk/*.apk

echo ""
echo "배포 권장 파일: app-arm64-v8a-release.apk (대부분의 최신 기기)"
echo "구형 기기 포함:  app-armeabi-v7a-release.apk"
