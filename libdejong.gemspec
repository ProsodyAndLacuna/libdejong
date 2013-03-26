# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'libdejong/version'

Gem::Specification.new do |s|
  s.name          = "libdejong"
  s.version       = LibDeJong::VERSION
  s.authors       = ["Marshall Mickelson"]
  s.email         = ["marshallmick+git@gmail.com"]
  s.homepage      = "https://github.com/marshallmick007/libdejong"
  s.summary       = "deJong Generator"
  s.description   = "Helps create deJong attactors"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency("yajl-ruby")
  s.add_dependency("chunky_png")
  s.add_dependency("oily_png")
  s.add_dependency("zipruby")
end
