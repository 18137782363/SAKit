Pod::Spec.new do |s|
  s.name         = 'SAKit'
  s.version      = '0.0.3'
  s.summary      = '对UIKit 适当封装'
  s.license      = 'MIT'
  s.author       = { '阿宝' => 'iosmobile@iscs.com.cn' }
  s.homepage     = 'https://github.com/ISCS-iOS'
  s.platform     = :ios,'7.0'
  s.ios.deployment_target = '7.0'
  s.source       = { :git => 'https://github.com/ISCSMobileOrg/SAKit.git', :tag => s.version.to_s}
  s.requires_arc = true
  s.source_files = 'SAKit/*.{h,m}'

  s.subspec 'SATransition' do |ss|
    ss.source_files = 'SAKit/SATransition/*.{h,m}'
  end

  s.subspec 'SACardView' do |ss|
    ss.source_files = 'SAKit/SACardView/*.{h,m}'
    ss.dependency 'SAKit/SATransition'
    ss.subspec 'SAAssistView' do |sss|
       sss.source_files = 'SAKit/SACardView/SAAssistView/*.{h,m}'
    end
  end

  s.subspec 'SACardInfoView' do |ss|
    ss.source_files = 'SAKit/SACardInfoView/*.{h,m}'
  end

  s.dependency 'MBProgressHUD', '~> 0.9.2'
  s.dependency 'Masonry', '~> 0.6.4'
end
