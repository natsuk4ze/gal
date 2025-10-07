#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gal.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gal'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin for handle native gallary apps.'
  s.homepage         = 'https://github.com/natsuk4ze/gal'
  s.license          = { :type => 'BSD-3-Clause', :file => '../LICENSE' }
  s.author           = { 'Midori Design Studio' => 'https://midoridesign.studio' }
  s.source           = { :http => 'https://github.com/natsuk4ze/gal' }
  s.source_files = 'gal/Sources/gal/**/*.swift'
  s.resource_bundles = {'gal_privacy' => ['gal/Sources/gal/PrivacyInfo.xcprivacy']}
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.15'

  # Flutter.framework does not contain a i386 slice.
  s.ios.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.osx.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
