#
# Be sure to run `pod lib lint KLAlertController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KLAlertController'
  s.version          = '0.0.1'
  s.summary          = '一款api跟系统UIAlertController一样的弹出视图，但是提供更多定制化的接口'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       一、支持iPhone和iPad，支持iOS6以上机型。
                       二、alertController由单独的window弹出，不用考虑presentingVc是谁。
                       三、alert支持自定义title、message、action属性，包括边距，内边距，文字属性等等。
                       四、popUp支持整个内容自定义，内容适配约束布局和绝对布局，内容支持滚动。
                       五、支持横竖屏适配，支持刘海屏适配。
                       六、支持多级弹框同时弹出，同一时间只显示一个弹框。支持设置弹窗优先级。
                       七、支持指定唯一identifier，相同的identifier只会显示一次。支持通过identifier移除。
                       DESC

  s.homepage         = 'https://github.com/xiamoon/KLAlertController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kaleo' => 'liqian_tvd@163.com' }
  s.source           = { :git => 'https://github.com/xiamoon/KLAlertController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'KLAlertController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KLAlertController' => ['KLAlertController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Masonry'
end
