require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../lib/tagged_timestamp_logger'
require_relative '../lib/grape_filter_logger'
require_relative '../lib/middleware/request_id'

# TODO: change name to application name
module YourApplication
  class Application < Rails::Application
    # Disable automatic test generation
    config.generators do |g|
      g.test_framework = nil
    end

    # Disable rails rack logging in grape endpoints
    config.middleware.swap Rails::Rack::Logger, GrapeFilterLogger

    # Load Grape API and enumerations
    config.paths.add 'app/api', glob: '**/*.rb'
    config.paths.add 'app/enums', glob: '**/*.rb'
    config.eager_load_paths << "#{config.root}/app"

    # Load STI folders
    config.eager_load_paths += Dir[Rails.root.join('app', 'models', '**/')]

    # Load lib
    config.eager_load_paths << "#{config.root}/lib"

    # Custom logger
    Dir.mkdir('log') unless File.directory?('log')

    config.logger = TaggedTimestampLogger.new("log/#{Rails.env}.log")
  end
end
