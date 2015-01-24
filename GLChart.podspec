#
# Be sure to run `pod lib lint GLChart.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GLChart"
  s.version          = "0.1.0"
  s.summary          = "Gildate Chart Component."
  s.description      = <<-DESC
                       A Gildate Chart Component.

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/luhuiguo/GLChart"
  s.license          = 'MIT'
  s.author           = { "Lu Huiguo" => "luhuiguo@gmail.com" }
  s.source           = { :git => "https://github.com/luhuiguo/GLChart.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/luhuiguo'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'GLChart' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'CorePlot', '~> 1.5.1'
  s.dependency 'AFNetworking', '~> 2.5.0'
  s.dependency 'MBProgressHUD', '~> 0.9'
  s.dependency 'MTDates', '~> 1.0.0'
  s.dependency 'FontAwesomeKit', '~> 2.2.0'
end
