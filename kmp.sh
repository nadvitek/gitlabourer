#!/bin/sh

set -e

./gradlew assembleXCFramework
cp -r -f shared/build/XCFrameworks/debug/ iosApp/
osascript -e 'display notification with title "KMP build ready"'

