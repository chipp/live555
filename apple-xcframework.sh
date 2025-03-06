#!/bin/sh

set -e

rm -rf build

declare -a PLATFORMS=("macosx-no-openssl" "xros" "xrsimulator" "ios" "iossimulator")

for PLATFORM in "${PLATFORMS[@]}"; do
    ./genMakefiles "$PLATFORM"
    make

    mkdir -p "build/$PLATFORM"
    mv liveMedia/liveMedia.framework "build/$PLATFORM"
    mv liveMedia/liveMedia.framework.dSYM "build/$PLATFORM"

    make distclean

    FRAMEWORKS="$FRAMEWORKS -framework $PWD/build/$PLATFORM/liveMedia.framework -debug-symbols $PWD/build/$PLATFORM/liveMedia.framework.dSYM"
done

xcodebuild -create-xcframework $FRAMEWORKS -output build/liveMedia.xcframework

cd build
zip -y -r -X liveMedia.xcframework.zip liveMedia.xcframework
cd ..
