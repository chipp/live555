#!/bin/sh

set -e

rm -rf build

declare -a PLATFORMS=("macosx-no-openssl" "xros" "xrsimulator" "ios" "iossimulator")

for PLATFORM in "${PLATFORMS[@]}"; do
    ./genMakefiles "$PLATFORM"
    make -j8

    mkdir -p "build/$PLATFORM"
    mv liveMedia/liveMedia.framework "build/$PLATFORM"

    make distclean

    FRAMEWORKS="$FRAMEWORKS -framework build/$PLATFORM/liveMedia.framework"
done

xcodebuild -create-xcframework $FRAMEWORKS -output build/liveMedia.xcframework
