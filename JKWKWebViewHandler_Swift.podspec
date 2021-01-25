#
# Be sure to run `pod lib lint JKWKWebViewHandler_Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKWKWebViewHandler_Swift'
  s.version          = '0.1.0'
  s.summary          = 'This is a tool of WKWebivew interact with H5,it write with swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a tool of WKWebivew interact with H5,it wirte with swift. it add a callback event of every JS funtion if needed. and when the ViewController will be destroyed all the callback events can be cleaned. it is different to the way create a new iframe and catch the url to interact with H5.
                       DESC

  s.homepage         = 'https://github.com/xindizhiyin2014/JKWKWebViewHandler_Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xindizhiyin2014' => '929097264@qq.com' }
  s.source           = { :git => 'https://github.com/xindizhiyin2014/JKWKWebViewHandler_Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'JKWKWebViewHandler_Swift/JKWKWebViewHandler_Swift/Classes/**/*'
  s.resources = 'JKWKWebViewHandler_Swift/JKWKWebViewHandler_Swift/Resources/*.js'
  s.swift_version='4.0'
  # s.resource_bundles = {
  #   'JKWKWebViewHandler_Swift' => ['JKWKWebViewHandler_Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
