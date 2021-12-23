# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"

ROOT = Pathname.new(__FILE__).join("..")

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:lint)

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = Dir[ROOT.join("lib/**/*.rb")]
  t.options = %w[--private]
end

namespace :doc do
  desc "Check documentation coverage"
  task coverage: :doc do
    YARD::Registry.load
    objs = YARD::Registry.select do |o|
      puts "pending #{o}" if /TODO|FIXME|@pending/.match?(o.docstring)
      o.docstring.blank?
    end

    next if objs.empty?
    puts "No documentation found for:"
    objs.each { |x| puts "\t#{x}" }

    raise "100% document coverage required"
  end
end

task default: %i[lint spec]
