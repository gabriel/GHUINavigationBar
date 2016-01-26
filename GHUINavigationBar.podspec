#
#  Be sure to run `pod spec lint GHUIKit.podspec` to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "GHUINavigationBar"
  s.version      = "0.1.1"
  s.summary      = "Navigation bar."
  s.homepage     = "https://github.com/gabriel/GHUINavigationBar"
  s.license      = "MIT"
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com" }
  s.source       = { :git => "https://github.com/gabriel/GHUINavigationBar", :tag => s.version.to_s }
  s.requires_arc = true

  s.platform     = :ios, "8.0"

  s.source_files = "GHUINavigationBar/**/*.{h,m}"
  s.dependency "GHKit"

end
