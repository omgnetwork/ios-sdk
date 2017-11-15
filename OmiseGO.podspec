Pod::Spec.new do |s|
  s.name = 'OmiseGO'
  s.version = '0.8.0'
  s.license = 'MIT'
  s.summary = 'The OmiseGO iOS SDK'
  s.homepage = 'https://omisego.network/'
  s.social_media_url = 'https://twitter.com/omise_go'
  s.authors = { 'OmiseGO team' => 'omg@omise.co' }
  s.source = { :git => 'ssh://git@phabricator.omisego.io/source/sdk-ios.git', :tag => s.version }

  s.platform = :ios, '9.0'

  s.source_files = 'Source/**/*.swift'
end
