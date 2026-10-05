# lzma-iosx

## Overview

`lzma-iosx` is a build and distribution project that produces the **liblzma static library from XZ Utils packaged as an XCFramework** for Apple platforms.

This repository **does not contain XZ Utils source code**. The source code is fetched from the official upstream repository:

[https://github.com/tukaani-project/xz](https://github.com/tukaani-project/xz)

using the corresponding upstream tag (for example `v5.8.4`).

---

## Supported XZ Utils Versions

Supported XZ Utils 5.8.x upstream versions: [5.8.4](https://github.com/apotocki/lzma-iosx/tree/5.8.4)

Supported XZ Utils 5.4.x upstream versions: [5.4.5](https://github.com/apotocki/lzma-iosx/tree/5.4.5), [5.4.2](https://github.com/apotocki/lzma-iosx/tree/5.4.2)


Use the appropriate **Git tag or branch** to select the desired XZ Utils version.

### Versioning Policy

Branches correspond to official XZ Utils versions.
Tags use the format `<xz_version>.<package_patch>` (e.g. `5.8.4.1`), where `package_patch` is this repository’s packaging/build revision for that upstream version.

---

## Supported Platforms

liblzma is built for:

* iOS / iOS Simulator
* watchOS / watchOS Simulator
* tvOS / tvOS Simulator
* visionOS / visionOS Simulator
* macOS
* Mac Catalyst

Both Intel (`x86_64`) and Apple Silicon (`arm64`) architectures are supported where applicable.

---

## Rationale

The macOS SDK ships `liblzma.tbd` and a set of headers from XZ Utils, but this set is incomplete: some headers are missing, and so is the corresponding functionality in the `.tbd` (for example `lzma_str_to_filters()`). Moreover, the SDK library cannot be used in an iOS application distributed through the App Store: Apple treats its symbols as non-public and rejects the submission.

---

## Prerequisites

1. **Install Xcode**
   Xcode is required because `xcodebuild` is used to create XCFrameworks.

2. **Verify Xcode Developer Directory**
   The `xcode-select -p` command must point to the Xcode developer directory (for example `/Applications/Xcode.app/Contents/Developer`).
   If it points to the Command Line Tools directory, reset it using one of the following commands:

   ```bash
   sudo xcode-select --reset
   ```
   or

   ```bash
   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
   ```

3. **Install CMake**
   CMake 3.20 or newer is required (for example `brew install cmake`).

4. **Install Required SDKs**
   To build for tvOS, watchOS, visionOS, and their simulators, make sure the corresponding SDKs are installed in:

   ```
   /Applications/Xcode.app/Contents/Developer/Platforms
   ```

---

## Build Manually

```bash
# clone the repository
git clone https://github.com/apotocki/lzma-iosx

# build libraries
cd lzma-iosx
scripts/build.sh

# build artifacts will be located in the `frameworks` directory
```

---

## Selecting Platforms and Architectures

Running `build.sh` without arguments builds the XCFramework for iOS, macOS, and Catalyst. If the corresponding SDKs are installed, it also builds for watchOS, tvOS, visionOS, and all available simulators.

The simulator architecture (`arm64` or `x86_64`) is selected automatically based on the host system.

To build a specific set of platforms and architectures, use the `-p` option. For example:

```bash
scripts/build.sh -p=ios,iossim-x86_64
# builds the XCFramework only for iOS devices and iOS Simulator (x86_64)
```

Supported values for the `-p` option:

```text
macosx,macosx-arm64,macosx-x86_64,macosx-both,
ios,iossim,iossim-arm64,iossim-x86_64,iossim-both,
catalyst,catalyst-arm64,catalyst-x86_64,catalyst-both,
xros,xrossim,xrossim-arm64,xrossim-x86_64,xrossim-both,
tvos,tvossim,tvossim-arm64,tvossim-x86_64,tvossim-both,
watchos,watchossim,watchossim-arm64,watchossim-x86_64,watchossim-both
```

The `-both` suffix builds for both `arm64` and `x86_64` architectures. Platform names without an architecture suffix (for example `macosx`, `iossim`) build only for the current host architecture.

---

## Rebuild Option

To force a clean rebuild without reusing artifacts from previous builds, use the `--rebuild` option:

```bash
scripts/build.sh -p=ios,iossim-x86_64 --rebuild
```

---

## Build Using CocoaPods

Add the following to your `Podfile`:

```ruby
use_frameworks!
pod 'lzma-iosx', '~> 5.8.4'
# or pin to a specific tag
# pod 'lzma-iosx', :git => 'https://github.com/apotocki/lzma-iosx', :tag => '5.8.4.1'
```

Then install the dependency:

```bash
pod install --verbose
```

---

## Contributions

Build outputs in this repository are generated from internal templates, so pull requests that directly modify generated files cannot be accepted. Please use **GitHub Issues** to report build problems or discuss changes, and include the XZ Utils version, target platform(s), and build command.

---

## License

This repository contains build scripts for liblzma.

Precompiled artifacts published via GitHub Releases are subject to the upstream XZ Utils license terms for the corresponding version (liblzma is distributed under the BSD Zero Clause License since XZ Utils 5.6.0 and is in the public domain in earlier versions).

---

## As an advertisement…

Please check out my iOS application on the App Store:

<table align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <a href="https://apps.apple.com/us/app/potohex/id1620963302">
        <img src="https://is4-ssl.mzstatic.com/image/thumb/Purple112/v4/78/d6/f8/78d6f802-78f6-267a-8018-751111f52c10/AppIcon-0-1x_U007emarketing-0-10-0-85-220.png/460x0w.webp" width="70" />
      </a>
    </td>
    <td>
      <a href="https://apps.apple.com/us/app/potohex/id1620963302">PotoHEX</a><br />
      HEX File Viewer &amp; Editor
    </td>
  </tr>
</table>

PotoHEX is designed for viewing and editing files at the byte or character level, calculating hashes, encoding/decoding data, and compressing/decompressing selected byte ranges.

If you find this project useful, you can support my open-source work by trying the [App](https://apps.apple.com/us/app/potohex/id1620963302).

---

Feedback is welcome!
