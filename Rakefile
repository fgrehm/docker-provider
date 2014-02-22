require "bundler/gem_tasks"
require 'rspec/core/rake_task'

namespace :spec do
  desc 'Run acceptance specs using Bats'
  task :acceptance do
    components = %w(
      basic network/forwarded_port synced_folder synced_folder/nfs
      provisioner/shell provisioner/puppet provisioner/chef-solo
    ).map{|s| "provider/docker/#{s}" }

    sh "bundle exec vagrant-spec test --components=#{components.join(' ')}"
  end

  require 'rspec/core/rake_task'
  desc "Run unit specs using RSpec"
  RSpec::Core::RakeTask.new('unit') do |t|
    t.pattern = "./unit/**/*_spec.rb"
  end
end

desc 'Run all specs'
task :spec => ['spec:unit', 'spec:acceptance']

task :default => 'spec'
