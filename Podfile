# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # websocket library
  pod 'Starscream', '~> 3.1'
  pod 'BigInt', '~> 4.0'
end

target 'OmiseGO' do
  shared_pods
end

target 'Tests' do
  shared_pods
end
