Pod::Spec.new do |s|
    s.name         = "lzma-iosx"
    s.version      = "5.4.5.0"
    s.summary      = "LZMA XCFramework for macOS and iOS, including both arm64 and x86_64 builds for macOS and Simulator."
    s.homepage     = "https://github.com/apotocki/lzma-iosx"
    s.license      = "BSD-3-Clause License"
    s.author       = { "Alexander Pototskiy" => "alex.a.potocki@gmail.com" }
    s.social_media_url = "https://www.linkedin.com/in/alexander-pototskiy"
    s.ios.deployment_target = "13.4"
    s.osx.deployment_target = "11.0"
    s.osx.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.ios.pod_target_xcconfig = { 'ONLY_ACTIVE_ARCH' => 'YES' }
    s.static_framework = true
    s.requires_arc = false
    s.prepare_command = "sh scripts/build.sh"
    s.source       = { :git => "https://github.com/apotocki/lzma-iosx.git", :tag => "#{s.version}" }

    s.header_mappings_dir = "frameworks/Headers"
    s.public_header_files = "frameworks/Headers/**/*.{h,H,c}"
    s.source_files = "frameworks/Headers/**/*.{h,H,c}"
    s.vendored_frameworks = "frameworks/lzma.xcframework"
        
    #s.preserve_paths = "frameworks/**/*"
end
