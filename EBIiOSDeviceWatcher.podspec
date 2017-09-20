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
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherits) "${PROJECT_DIR}/Pods/EBIiOSDeviceWatcher_Frameworks"' }
  s.framework = 'MobileDevice'
  s.prepare_command = <<EOS
    SUPPORT_DIR=`find . -name 'Target Support Files' | head -n 1`
    FRAMEWORK_DIR=`dirname "$SUPPORT_DIR"`"/EBIiOSDeviceWatcher_Frameworks"
    mkdir -p $FRAMEWORK_DIR
    cp -r /System/Library/PrivateFrameworks/MobileDevice.framework "$FRAMEWORK_DIR/"
EOS
end
