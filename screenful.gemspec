# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "screenful/version"

Gem::Specification.new do |s|
  s.name				= "screenful"
  s.version				= Screenful::VERSION
  s.platform			= Gem::Platform::RUBY
  s.authors				= ["Piotr Dubiel"]
  s.summary				= %q{Screenful is cucumber formatter for calabash that allows intercepting touches}
  s.add_dependency("calabash-common")
  s.files 				=  ["lib/screenful.rb", 
                      "lib/screenful/formatter.rb",
                      "lib/screenful/version.rb",
                      "lib/screenful/intercept.rb",
                      "lib/screenful/interceptors/android.rb",
                      "lib/screenful/interceptors/ios.rb",
                      "lib/screenful/screenshot_helper.rb"]

  s.require_paths = ["lib"]
end
