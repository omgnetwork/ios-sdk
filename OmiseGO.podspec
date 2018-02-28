Pod::Spec.new do |s|
  s.name = 'OmiseGO'
  s.version = '0.9.7'
  s.license = 'Apache'
  s.summary = 'The OmiseGO iOS SDK allows developers to easily interact with a node of the OmiseGO eWallet.'
  s.homepage = 'https://omisego.network/'
  s.social_media_url = 'https://twitter.com/omise_go'
  s.authors = { 'OmiseGO team' => 'omg@omise.co' }
  s.source = { :git => 'https://github.com/omisego/ios-sdk.git', :tag => s.version }

  s.platform = :ios, '9.0'
  s.swift_version = '4.0'

  s.source_files = 'Source/**/*.swift'
end
