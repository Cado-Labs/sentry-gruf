# frozen_string_literal: true

require_relative "lib/sentry/gruf/version"

Gem::Specification.new do |spec|
  spec.name = "sentry-gruf"
  spec.version = Sentry::Gruf::VERSION
  spec.authors = ["JustAnotherDude"]
  spec.email = ["vanyaz158@gmail.com"]

  spec.summary = "Gruf both client and server interceptors, which report bugs to the Sentry."
  spec.description = "Gruf both client and server interceptors, which report bugs to the Sentry."
  spec.homepage = "https://github.com/orgs/Cado-Labs"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/orgs/Cado-Labs"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) ||
        f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gruf", "~> 2.10.0"
  spec.add_dependency "sentry-ruby-core", "~> 4.8.1"
end
