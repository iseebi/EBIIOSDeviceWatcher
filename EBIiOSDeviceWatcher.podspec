Pod::Spec.new do |s|
  s.name         = "EBIiOSDeviceWatcher"
  s.version      = "0.1.0"
  s.summary      = "Observe iOS device connect/disconnect on macOS."
  s.homepage     = "https://github.com/iseebi/EBIiOSDeviceWatcher"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Nobuhiro Ito" => "iseebi@iseteki.net" }
  s.social_media_url = "https://twitter.com/iseebi"
  s.platform     = :osx, "10.9"
  s.source       = { :git => "https://github.com/iseebi/EBIiOSDeviceWatcher.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/EBI*.h"
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherits) "${PODS_ROOT}/EBIiOSDeviceWatcher/Frameworks"' }
  s.framework = 'MobileDevice'
  s.preserve_paths = 'Frameworks/*.framework'
  s.prepare_command = <<EOS
    mkdir -p ./Frameworks;
    cp -r /System/Library/PrivateFrameworks/MobileDevice.framework ./Frameworks/;
EOS
    #SUPPORT_DIR=`find . -name 'Target Support Files' | head -n 1`
    #FRAMEWORK_DIR=`dirname "$SUPPORT_DIR"`"/EBIiOSDeviceWatcher/Frameworks"
    #mkdir -p $FRAMEWORK_DIR
    #cp -r /System/Library/PrivateFrameworks/MobileDevice.framework "$FRAMEWORK_DIR/"
end
