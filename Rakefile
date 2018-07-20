JAZZY_CONFIG = '.jazzy.yml'

desc 'Generate API Reference'
task :docs do
  `jazzy --config #{JAZZY_CONFIG}`
end

task :changelog do
  `github_changelog_generator omisego/ios-sdk`
end

task :prepare_release do
  Rake::Task["docs"].invoke
  Rake::Task["changelog"].invoke
end
