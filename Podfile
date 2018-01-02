# Uncomment the next line to define a global platform for your project

platform :ios, '9.0'


use_frameworks!

def common_pods
    pod 'RxSwift',    '~> 4.0'
    pod 'RxCocoa',    '~> 4.0'
end

target 'Example-iOS' do
    common_pods
    pod 'RxDataSources', '~> 3.0.2'
end

target 'RxElegantReuse-iOS' do
    common_pods
end

target 'RxElegantReuse-tvOS' do
    common_pods
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
            target.build_configurations.each do |config|
                if config.name == 'Debug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
            end
        end
    end
end

