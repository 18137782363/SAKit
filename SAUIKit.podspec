Pod::Spec.new do |s|
  s.name         = "SAUIKit"
  s.version      = "0.0.1"
  s.summary      = "UIKit 浅度封装"
  s.license      = 'MIT'
  s.author       = { "阿宝" => "iosmobile@iscs.com.cn" }
  s.homepage     = "https://github.com/ISCS-iOS/SAUIKit"
  s.platform     = :ios,'7.0'
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/ISCS-iOS/SAUIKit.git", :tag => s.version.to_s}
  s.requires_arc = true
  s.source_files = 'SAUIKitClass/*.{h,m}'
  s.dependency 'MBProgressHUD', '~> 0.9.2'
end