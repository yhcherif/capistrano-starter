# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/starter/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-starter"
  spec.version       = Capistrano::Starter::VERSION
  spec.authors       = ["Youssouf Cherif"]
  spec.email         = ["youssouf.cherif.hamed@gmail.com"]

  spec.summary       = %q{Capistrano starter kit.}
  spec.description   = %q{Let lazify do all the deploying stuff for you. Once you've finished you dev, it take a coffee break to deploy you laravel,Vanilla php or ruby. It can add a local dns tht point on the remote server, create a mysql database for you, set environment variables and even generate a nginx configuration for you app. The funny thing, it can setup you your server given a language. Install all required packages.}
  spec.homepage      = "http://youssoufcherif.me"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'capistrano', '~> 3.1'
  spec.add_dependency 'sshkit', '~> 1.2'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
