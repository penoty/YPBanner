#
# Be sure to run `pod lib lint YPBanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "YPBanner"
  s.version          = "0.1.0"
  s.summary          = "Just a few lines of codes, you can easily add a banner to your project."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "Just a few lines of codes, you can easily add a banner to your project."
  s.homepage         = "https://github.com/penoty/YPBanner"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "penoty" => "penoty@163.com" }
  s.source           = { :git => "https://github.com/penoty/YPBanner.git", :tag => s.version.to_s }
  s.social_media_url = 'weixin:penotydelpiero'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'YPBanner' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/YPBanner/YPBannerView.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SDWebImage', '~> 3.7.3'
end
