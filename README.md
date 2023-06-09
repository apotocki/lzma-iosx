## LZMA for iOS and Mac OS X (Intel & Apple Silicon M1) - arm64 / x86_64

Supported version: 5.4.2

This repo provides a universal script for building static liblzma library for use in iOS and Mac OS X applications.
The actual library version is taken from https://github.com/tukaani-project/xz with tag 'v5.4.2'

## Rationale
 Current MacOSX SDK contains liblzma.tbd and some set of headers related to the tukaani-project/xz product. But this set is not complete. Some headers are missed and corresponded functionality is also missed in the tbd (e.g. lzma_str_to_filters() function). But the saddest thing is that's impossible to embed this tbd into the IOS project for Apple Store distribution. Apple finds that all the definitions from the library as "the non-public symbols" and rejects a submission.

## Prerequisites
  1) Xcode must be installed because xcodebuild is used to create xcframeworks
  2) ```xcode-select -p``` must point to Xcode app developer directory (by default e.g. /Applications/Xcode.app/Contents/Developer). If it points to CommandLineTools directory you should execute:
  ```sudo xcode-select --reset``` or ```sudo xcode-select -s /Applications/Xcode.app/Contents/Developer```
  3) CMake (at least version 3.13) must be installed (e.g. by brew install cmake) 

## How to build?
 - Manually
```
    # clone the repo
    git clone -b 5.4.2 https://github.com/apotocki/lzma-iosx
    
    # build libraries
    cd lzma-iosx
    scripts/build.sh

    # have fun, the result artifacts will be located in 'frameworks' folder.
```    
 - Use cocoapods. Add the following lines into your project's Podfile:
```
    use_frameworks!
    pod 'lzma-iosx', '~> 5.4.2'
    # or optionally more precisely
    # pod 'lzma-iosx', :git => 'https://github.com/apotocki/lzma-iosx', :tag => '5.4.2.0'
```    
install new dependency:
```
   pod install --verbose
```

## As an advertisement…
The LZMA XCFramework built by this project is used in my iOS application on the App Store:

[<table align="center" border=0 cellspacing=0 cellpadding=0><tr><td><img src="https://is4-ssl.mzstatic.com/image/thumb/Purple112/v4/78/d6/f8/78d6f802-78f6-267a-8018-751111f52c10/AppIcon-0-1x_U007emarketing-0-10-0-85-220.png/460x0w.webp" width="70"/></td><td><a href="https://apps.apple.com/us/app/potohex/id1620963302">PotoHEX</a><br>HEX File Viewer & Editor</td><tr></table>]()

This app is designed for viewing and editing files at byte or character level.
  
You can support my open-source development by trying the [App](https://apps.apple.com/us/app/potohex/id1620963302).

Feedbacks are also welcome!