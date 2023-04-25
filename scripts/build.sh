#!/bin/bash
set -e
################## SETUP BEGIN
# brew install git git-lfs
THREAD_COUNT=$(sysctl hw.ncpu | awk '{print $2}')
HOST_ARC=$( uname -m )
XZ_VER=v5.4.2
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BUILD_DIR="$( cd "$( dirname "./" )" >/dev/null 2>&1 && pwd )"
#XCODE_ROOT=$( xcode-select -print-path )
################## SETUP END
#MACSYSROOT=$XCODE_ROOT/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk

XZ_VER_NAME=xz_${XZ_VER//./_}

[ -d $BUILD_DIR/frameworks ] && rm -rf $BUILD_DIR/frameworks

[ ! -d $XZ_VER_NAME ] && echo downloading $XZ_VER ... && git clone --depth 1 -b $XZ_VER https://github.com/tukaani-project/xz $XZ_VER_NAME

echo building $XZ_VER "(-j$THREAD_COUNT)" ...

[ -d $BUILD_DIR/build ] && rm -rf $BUILD_DIR/build


generic_build()
{
if [[ ! -d $BUILD_DIR/build.$1.${2//;/_} ]]; then
	echo "BUILDING $1 $2"
	mkdir $BUILD_DIR/build
	pushd $BUILD_DIR/build

	echo "running configure"
	cmake $4 -DCMAKE_OSX_ARCHITECTURES=$2 -DBUILD_SHARED_LIBS=OFF -GXcode ../$XZ_VER_NAME
	#cmake $4 -DCMAKE_OSX_ARCHITECTURES=$2 -DCRYPTO_BACKEND=OpenSSL -DOPENSSL_INCLUDE_DIR="$OPENSSL_PATH/Headers" -DOPENSSL_SSL_LIBRARY="$OPENSSL_PATH/ssl.xcframework/$6/libssl.a" -DOPENSSL_CRYPTO_LIBRARY="$OPENSSL_PATH/crypto.xcframework/$6/libcrypto.a" -DCMAKE_C_FLAGS="-DOPENSSL_NO_ENGINE -Wno-shorten-64-to-32 $5" -DENABLE_ZLIB_COMPRESSION=ON -DBUILD_SHARED_LIBS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/frameworks -GXcode ../$XZ_VER_NAME

	echo "running build"
	#CODE_SIGNING_ALLOWED=NO
	cmake --build . --config Release --target liblzma -- $3 -j $THREAD_COUNT
	popd
	mv $BUILD_DIR/build $BUILD_DIR/build.$1.${2//;/_}
fi
}

generic_build ios arm64 "-sdk iphoneos" "-DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_DEPLOYMENT_TARGET=13.4" "-fembed-bitcode" "ios-arm64"
generic_build simulator "arm64;x86_64" "-sdk iphonesimulator" "-DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_DEPLOYMENT_TARGET=13.4" "-fembed-bitcode" "ios-*-simulator"
generic_build osx "arm64;x86_64" "" "-DCMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH=NO -DCMAKE_IOS_INSTALL_COMBINED=YES" "" "macos-*"

#mkdir $BUILD_DIR/frameworks
xcodebuild -create-xcframework -library $BUILD_DIR/build.ios.arm64/Release-iphoneos/liblzma.a -library $BUILD_DIR/build.simulator.arm64_x86_64/Release-iphonesimulator/liblzma.a -library $BUILD_DIR/build.osx.arm64_x86_64/Release/liblzma.a -output $BUILD_DIR/frameworks/lzma.xcframework
[[ ! -d $BUILD_DIR/frameworks/Headers ]] && mkdir $BUILD_DIR/frameworks/Headers
cp $XZ_VER_NAME/src/liblzma/api/*.h $BUILD_DIR/frameworks/Headers/
cp -r $XZ_VER_NAME/src/liblzma/api/lzma $BUILD_DIR/frameworks/Headers/


