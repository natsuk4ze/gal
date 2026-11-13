#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gal.podspec` to validate before publishing.
#
require 'yaml'
pubspec = YAML.load_file(File.join(__dir__, '..', 'pubspec.yaml'))

Pod::Spec.new do |s|
  s.name             = 'gal'
  s.version          = pubspec['version']
  s.summary          = pubspec['description'].strip
  s.homepage         = pubspec['repository']
  s.license          = { :type => 'BSD-3-Clause', :file => '../LICENSE' }
  s.author           = { 'Midori Design Studio' => 'https://midoridesign.studio' }
  s.source           = { :http => 'https://github.com/natsuk4ze/gal' }
  s.source_files = 'gal/Sources/gal/**/*.swift'
  s.resource_bundles = {'gal_privacy' => ['gal/Sources/gal/PrivacyInfo.xcprivacy']}
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.ios.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.osx.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
