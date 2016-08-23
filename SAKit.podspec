Pod::Spec.new do |s|
  s.name         = 'SAKit'
  s.version      = '0.0.2'
  s.summary      = '对UIKit 适当封装'
  s.license      = 'MIT'
  s.author       = { '阿宝' => 'iosmobile@iscs.com.cn' }
  s.homepage     = 'https://github.com/ISCS-iOS'
  s.platform     = :ios,'7.0'
  s.ios.deployment_target = '7.0'
  s.source       = { :git => 'https://github.com/ISCS-iOS/SAKit.git', :tag => s.version.to_s}
  s.requires_arc = true
  s.source_files = 'SAKit/*.{h,m}'

  s.dependency 'MBProgressHUD', '~> 0.9.2'
end
