require_relative 'lib/securenv/version'

Gem::Specification.new do |spec|
  spec.name          = "securenv"
  spec.version       = Securenv::VERSION
  spec.authors       = ["Jeremy Green"]
  spec.email         = ["jeremy@octolabs.com"]

  spec.summary       = %q{Securely store and set ENV variables via AWS SSM.}
  spec.description   = %q{Securely store and set ENV variables via AWS SSM.}
  spec.homepage      = "https://github.com/Octo-Labs/securenv"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Octo-Labs/securenv"
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "thor" # Thor drives the CLI

  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end
