require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint'

# disable the 80 character check
PuppetLint.configuration.send("disable_80chars")

# Default tasks
task :default => [:lint, :spec]
