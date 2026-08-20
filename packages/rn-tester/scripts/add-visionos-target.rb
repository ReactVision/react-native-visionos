#!/usr/bin/env ruby
# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

# Adds the RNTester-visionOS application target to RNTesterPods.xcodeproj.
#
# The target is generated instead of being merged by hand so that syncing this
# fork with a new React Native version only requires re-running this script on
# top of the upstream project file:
#
#     ruby packages/rn-tester/scripts/add-visionos-target.rb
#
# Pod-derived build settings (HEADER_SEARCH_PATHS, SWIFT_INCLUDE_PATHS, the
# libPods link and the [CP] script phases) are deliberately left out: CocoaPods
# writes them on `pod install`.

require 'xcodeproj'

TARGET_NAME = 'RNTester-visionOS'
PROJECT_PATH = File.expand_path('../RNTesterPods.xcodeproj', __dir__)

COMMON_SETTINGS = {
  'ASSETCATALOG_COMPILER_APPICON_NAME' => 'AppIcon',
  'ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS' => 'YES',
  'ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME' => 'AccentColor',
  'CLANG_ANALYZER_NONNULL' => 'YES',
  'CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION' => 'YES_AGGRESSIVE',
  'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++20',
  'CLANG_ENABLE_OBJC_WEAK' => 'YES',
  'CLANG_WARN_UNGUARDED_AVAILABILITY' => 'YES_AGGRESSIVE',
  'CODE_SIGN_STYLE' => 'Automatic',
  'CURRENT_PROJECT_VERSION' => '1',
  'DEVELOPMENT_ASSET_PATHS' => '"RNTester-visionOS/Preview Content"',
  'ENABLE_PREVIEWS' => 'YES',
  'ENABLE_USER_SCRIPT_SANDBOXING' => 'NO',
  'GCC_C_LANGUAGE_STANDARD' => 'gnu17',
  'GENERATE_INFOPLIST_FILE' => 'YES',
  'INFOPLIST_FILE' => '$(TARGET_NAME)/Info.plist',
  'LD_RUNPATH_SEARCH_PATHS' => ['/usr/lib/swift', '$(inherited)', '@executable_path/Frameworks'],
  'LOCALIZATION_PREFERS_STRING_CATALOGS' => 'YES',
  'MARKETING_VERSION' => '1.0',
  'MTL_FAST_MATH' => 'YES',
  'PRODUCT_BUNDLE_IDENTIFIER' => 'com.meta.RNTester.localDevelopment.RNTester-visionOS',
  'PRODUCT_NAME' => '$(TARGET_NAME)',
  'SUPPORTED_PLATFORMS' => 'xros xrsimulator',
  'SWIFT_EMIT_LOC_STRINGS' => 'YES',
  'SWIFT_VERSION' => '5.0',
  'TARGETED_DEVICE_FAMILY' => '1,2,7',
}.freeze

DEBUG_SETTINGS = {
  'DEBUG_INFORMATION_FORMAT' => 'dwarf',
  'MTL_ENABLE_DEBUG_INFO' => 'INCLUDE_SOURCE',
  'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'DEBUG $(inherited)',
  'SWIFT_OPTIMIZATION_LEVEL' => '-Onone',
}.freeze

RELEASE_SETTINGS = {
  'COPY_PHASE_STRIP' => 'NO',
  'DEBUG_INFORMATION_FORMAT' => 'dwarf-with-dsym',
  'SWIFT_COMPILATION_MODE' => 'wholemodule',
}.freeze

BUNDLE_JS_SCRIPT = <<~SH
  set -e

  export PROJECT_ROOT="$SRCROOT"
  export ENTRY_FILE="$SRCROOT/js/RNTesterApp.ios.js"
  export SOURCEMAP_FILE=../sourcemap.ios.map

  WITH_ENVIRONMENT="../react-native/scripts/xcode/with-environment.sh"
  REACT_NATIVE_XCODE="../react-native/scripts/react-native-xcode.sh"

  /bin/sh -c "$WITH_ENVIRONMENT $REACT_NATIVE_XCODE"
SH

project = Xcodeproj::Project.open(PROJECT_PATH)

if project.targets.any? { |t| t.name == TARGET_NAME }
  puts "#{TARGET_NAME} already exists, nothing to do."
  exit 0
end

group = project.main_group.find_subpath(TARGET_NAME, true)
group.set_source_tree('<group>')
group.set_path(TARGET_NAME)

preview_group = group.find_subpath('Preview Content', true)
preview_group.set_source_tree('<group>')
preview_group.set_path('Preview Content')

target = project.new_target(:application, TARGET_NAME, :ios, nil, nil, :swift)

target.build_configurations.each do |config|
  extra = config.name == 'Release' ? RELEASE_SETTINGS : DEBUG_SETTINGS
  config.build_settings = COMMON_SETTINGS.merge(extra)
end

%w[App.swift AppDelegate.swift].each do |name|
  target.add_file_references([group.new_reference(name)])
end

resources = [
  group.new_reference('Assets.xcassets'),
  preview_group.new_reference('Preview Assets.xcassets'),
  group.new_reference('../RNTester/PrivacyInfo.xcprivacy'),
]
target.add_resources(resources)

# Info.plist is referenced through INFOPLIST_FILE, but keep it visible in the
# project navigator.
group.new_reference('Info.plist')

bundle_js = target.new_shell_script_build_phase('Build JS Bundle')
bundle_js.shell_path = '/bin/sh'
bundle_js.shell_script = BUNDLE_JS_SCRIPT
bundle_js.input_paths = ['$(SRCROOT)/.xcode.env.local', '$(SRCROOT)/.xcode.env']

# A shared scheme is required for `xcodebuild -scheme RNTester-visionOS` in CI.
scheme = Xcodeproj::XCScheme.new
scheme.add_build_target(target)
scheme.set_launch_target(target)
scheme.save_as(PROJECT_PATH, TARGET_NAME, true)

project.save

puts "Added #{TARGET_NAME} target and shared scheme to #{File.basename(PROJECT_PATH)}."
