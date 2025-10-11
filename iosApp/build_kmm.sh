#!/bin/sh

set -e

( cd .. && ./gradlew assembleXCFramework )
# cp -r -f shared/build/XCFrameworks/debug/ ./
osascript -e 'display notification with title "KMP build ready"'

