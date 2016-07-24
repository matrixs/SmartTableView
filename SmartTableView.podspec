#
# Be sure to run `pod lib lint SmartTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SmartTableView'
  s.version          = '0.1.0'
  s.summary          = 'Make TableView work done in a minute.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An Extension of UITableView, which use autolayout to calculate and cache tableview cell height automatically , free your time.
                       DESC

  s.homepage         = 'https://github.com/matrixs/SmartTableView.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'matrixs' => '363986099@qq.com' }
  s.source           = { :git => 'https://github.com/matrixs/SmartTableView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'source/**/*'
end
