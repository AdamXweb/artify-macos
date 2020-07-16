source 'https://github.com/CocoaPods/Specs.git'

platform :osx, '10.12'
use_frameworks!
inhibit_all_warnings!
workspace 'DesktopaintWorkspace.xcworkspace'

#
# ============================= Desktopaint ==================================
#

def pod_required
    pod 'RxSwift' , '~> 4.0.0'
    pod 'RxCocoa' , '~> 4.0.0'
    pod 'RxOptional'
    pod 'Alamofire'
    pod 'Unbox'
    pod 'Wrap'
    pod 'Action'
    pod 'RxOptional'
    pod 'Moya/RxSwift', '~> 11.0'
    pod 'RxNuke'
    pod 'Sparkle'
end


# Desktopaint
target 'Desktopaint' do
    project 'Desktopaint/Desktopaint.xcodeproj'
    pod_required
end

#
# ============================= Desktopaint Core ==================================
#

# Desktopaint Core
target 'desktopaint-core' do
    project 'desktopaint-core/desktopaint-core.xcodeproj'
    pod_required
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
