if RUBY_ENGINE == 'ruby'
  require 'simplecov'
  require 'codeclimate-test-reporter'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
  SimpleCov.start
end

require 'omnidesk_auth'

RSpec.configure do |config|
end
