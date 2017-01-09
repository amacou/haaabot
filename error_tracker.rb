require 'rollbar'

if rollbar_access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  Rollbar.configure do |config|
    config.access_token = rollbar_access_token
  end

  module Ruboty
    class Robot
      def receive_with_rollbar(attributes)
        original_receive(attributes)
      rescue => e
        Rollbar.error(e)
        Ruboty.die(e)
      end

      alias original_receive receive
      alias receive receive_with_rollbar
    end
  end
end
