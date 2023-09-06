#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gal.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gal'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin for handle native gallary apps.'
  s.homepage         = 'https://github.com/natsuk4ze/gal'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Midori Design Studio' => 'https://midoridesign.studio' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '11.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
