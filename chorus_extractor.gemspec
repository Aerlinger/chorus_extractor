# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chorus_extractor/version'

Gem::Specification.new do |spec|
  spec.name          = "chorus_extractor"
  spec.version       = ChorusExtractor::VERSION
  spec.authors       = ["Anthony Erlinger"]
  spec.email         = ["aerlinger@gmail.com"]
  spec.description   = %q{Extracts lyrics from a text file by finding matching lines}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "colorize"
  spec.add_development_dependency "rmagick"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency "guard-rspec"
  spec.add_runtime_dependency "diff-lcs"
end
