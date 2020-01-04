
Pod::Spec.new do |s|
  s.name             = 'KLAlertController'
  s.version          = '0.1.0'
  s.summary          = '一款api跟系统UIAlertController一样的弹出视图，但是提供更多定制化的接口'

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
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kaleo' => 'liqian_tvd@163.com' }
  s.source           = { :git => 'https://github.com/xiamoon/KLAlertController.git', :tag => s.version.to_s}
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.dependency 'Masonry'

  s.source_files = 'KLAlertController/Classes/**/*'
#  s.public_header_files = 'KLAlertController/Classes/**/*.h'
  
#  s.subspec 'Other' do |other|
#    other.source_files = 'KLAlertController/Classes/Other/*.{h,m}'
##    ss.public_header_files = 'KLAlertController/Other/*.h'
#  end
#
#  s.subspec 'Animation' do |animation|
#    animation.source_files = 'KLAlertController/Classes/Animation/*.{h,m}'
##    ss.public_header_files = 'KLAlertController/Animation/*.h'
#  end
#
#  s.subspec 'Model' do |model|
#    model.source_files = 'KLAlertController/Classes/Model/*.{h,m}'
##    ss.public_header_files = 'KLAlertController/Model/KLAlertAction.h'
#  end
#
#  s.subspec 'View' do |view|
#    view.source_files = 'KLAlertController/Classes/View/**/*.{h,m}'
##    ss.public_header_files = 'KLAlertController/View/*.h'
#
#    view.subspec 'Alert' do |alert|
#      alert.dependency 'KLAlertController/Classes/Model'
#      alert.dependency 'KLAlertController/Classes/Other'
#
#      alert.source_files = 'KLAlertController/Classes/View/Alert/*.{h,m}'
##      sss.public_header_files = 'KLAlertController/View/Alert/*.h'
#    end
#
#    view.subspec 'Sheet' do |sheet|
#      sheet.dependency 'KLAlertController/Classes/View/Alert'
#
#      sheet.source_files = 'KLAlertController/Classes/View/Sheet/*.{h,m}'
##      sss.public_header_files = 'KLAlertController/View/Sheet/*.h'
#    end
#  end
end
