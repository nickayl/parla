platform :ios, '9.0'
use_frameworks!

def parla_pods
  pod 'SKPhotoBrowser', '~> 6.1.0'
  pod 'SDWebImage', '~> 5.0.2'
end

target 'parla' do
  parla_pods

  target 'parlaTests' do
    inherit! :search_paths
  end
  
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
