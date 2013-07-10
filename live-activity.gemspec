# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "live_activity/version"

Gem::Specification.new do |s|
  s.name        = "live-activity"
  s.version     = LiveActivity::VERSION
  s.authors     = ["Andreas Saebjoernsen"]
  s.email       = ["andreas.saebjoernsen@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Activity Streams for rails}
  s.description = %q{LiveActivity is a simple activity stream gem for use with the ActiveRecord ODM framework}
  s.homepage    = 'https://github.com/digitalplaywright/live-activity'

  s.rubyforge_project = "live-activity"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activerecord', '>= 3'
  s.add_dependency 'activesupport', '>= 3'
  s.add_dependency 'actionpack', '>= 3'
  s.add_development_dependency 'rake'

end
