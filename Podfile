platform :ios, '9.0'
use_frameworks!

def parla_pods
  pod 'SKPhotoBrowser', '~> 6.1.0'
  pod 'MobilePlayer', '~> 1.3.0'
end

target 'parla' do
  parla_pods

  target 'parlaTests' do
    inherit! :search_paths
  end

end

target 'ParlaKit' do
  parla_pods
end
