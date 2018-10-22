Pod::Spec.new do |s|
  s.name = 'OmiseGO'
  s.version = '1.1.0-beta1'
  s.license = 'Apache'
  s.summary = 'The OmiseGO iOS SDK allows developers to easily interact with a node of the OmiseGO eWallet.'
  s.homepage = 'https://github.com/omisego/ios-sdk'
  s.social_media_url = 'https://twitter.com/omise_go'
  s.authors = { 'OmiseGO team' => 'omg@omise.co' }
  s.source = { :git => 'https://github.com/omisego/ios-sdk.git', :tag => s.version }

  s.platform = :ios, '10.0'
  s.swift_version = '4.2'

  s.subspec 'Core' do |ss|
    ss.source_files = "Source/Core/**/*.swift"
    ss.dependency 'Starscream', '~> 3.0'
    ss.dependency 'BigInt', '~> 3.1'
  end

  s.subspec 'Client' do |ss|
    ss.source_files = "Source/Client/**/*.swift"
    ss.dependency 'OmiseGO/Core'
  end

  s.subspec 'Admin' do |ss|
    ss.source_files = "Source/Admin/**/*.swift"
    ss.dependency 'OmiseGO/Core'
  end

end
