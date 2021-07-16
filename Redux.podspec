#
# Be sure to run `pod lib lint Redux.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Redux"
  s.version          = "0.1.2"
  s.summary          = "Swift implementation of Redux."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
A Swift implementation of rackt/redux by Dan Abramov and the React Community.
                       DESC

  s.homepage         = "https://github.com/oursky/Redux"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Steven-Chan" => "stevenchan@oursky.com" }
  s.source           = { :git => "https://github.com/oursky/Redux.git", :tag => s.version.to_s }
  s.ios.deployment_target = "9.0"
  s.source_files = 'Pod/Classes/**/*'
  s.swift_versions = ['5.0', '5.1', '5.2']
end
