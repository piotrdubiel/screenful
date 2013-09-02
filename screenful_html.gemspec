# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "screenful_html/version"

Gem::Specification.new do |s|
  s.name				= "screenful_html"
  s.version				= ScreenfulHtml::VERSION
  s.platform			        = Gem::Platform::RUBY
  s.authors				= ["Piotr Dubiel"]
  s.summary				= %q{ScreenfulHtml is cucumber formatter for calabash that allows intercepting touches}
  s.add_dependency "calabash-cucumber"
  s.add_dependency "rmagick"
  s.files 				=  ["lib/screenful_html.rb", 
                                            "lib/screenful_html/formatter.rb",
                                            "lib/screenful_html/version.rb",
                                            "lib/screenful_html/action_interceptor.rb",
                                            "lib/screenful_html/screenshot_helper.rb"]

  s.require_paths = ["lib"]
end
