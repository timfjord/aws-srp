# frozen_string_literal: true

require_relative 'lib/aws_srp/version'

Gem::Specification.new do |spec|
  spec.name          = 'aws-srp'
  spec.version       = AwsSRP::VERSION
  spec.authors       = ['Tim Masliuchenko']
  spec.email         = ['insside@gmail.com']

  spec.summary       = %q{AWS Cognito SRP Utility}
  spec.description   = %q{AWS Cognito SRP Utility}
  spec.homepage      = 'https://github.com/timsly/aws-srp'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/timsly/aws-srp'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
