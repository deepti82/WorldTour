platform :ios, '10.0'

target 'TraveLibro' do
  pod 'HanekeSwift', :git=> 'https://github.com/Haneke/HanekeSwift.git', :branch => 'feature/swift-3'
  pod 'BSImagePicker', '~> 2.4'
  pod 'DKChainableAnimationKit', :git=> 'https://github.com/Draveness/DKChainableAnimationKit.git', :branch => 'master'
  pod 'TabPageViewController', :git=> 'https://github.com/EndouMari/TabPageViewController.git', :branch => 'swift_3'
  pod 'SwiftHTTP', '~> 2.0.0'
  pod 'Simplicity'
  pod 'TwitterKit'
  pod 'TwitterCore'
  pod 'SQLite.swift', :git=> 'https://github.com/stephencelis/SQLite.swift.git', :branch => 'prepare-0.11.1'
  pod 'imglyKit', '~> 5.0'
  pod 'Dollar'
  pod 'Cent'
  pod 'AsyncSwift'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
  pod 'Toaster', '~> 2.0'
  pod 'Player', '~> 0.2.0'
  pod 'Google/Analytics'
  pod 'OneSignal'
end

use_frameworks!

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
