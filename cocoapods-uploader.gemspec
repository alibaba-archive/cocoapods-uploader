# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-uploader/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-uploader'
  spec.version       = CocoapodsUploader::VERSION
  spec.authors       = ['supern_lee']
  spec.email         = ['supern.lee@gmail.com']
  spec.description   = %q{Upload file/dir to remote storage.}
  spec.summary       = %q{Upload file/dir to remote storage.}
  spec.homepage      = 'https://github.com/alibaba/cocoapods-uploader'
  spec.license       = 'MIT'

  spec.files = Dir['lib/**/*.rb']
  spec.files += Dir['[A-Z]*'] + Dir['test/**/*']
  # spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rest-client', '~> 1.6'
  spec.add_runtime_dependency 'rubyzip', '~> 1.0'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~>0'
end
