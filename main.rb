require 'open-uri'
require './error_tracker'

module Ruboty
  module Handlers
    class Haaabot < Base
      on(
        /はー[…\.]+[\s　]*(?<keyword>[[\S]&&[^　]]+)/,
        name: 'haaa',
        all: true,
        description: 'はー…のあとの文字を検索します'
      )

      def haaa(message)
        return if filtering_by_user? && message.from != filtering_user

        Retryable.retryable(tries: 5, on: [OpenURI::HTTPError, ::Twitter::Error::UnacceptableIO]) do
          url = search(message[:keyword])
          text = "#{message[:keyword]}! #{url}"
          bot.update_with_media(text, open(url))
        end
      end

      private

      def search(query)
        Ruboty::GoogleImage::Client.new(query: query).get
      end

      def filtering_by_user?
        !filtering_user.nil?
      end

      def filtering_user
        ENV['FILTERING_USER']
      end

      def bot
        @bot ||= ::Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['BOT_TWITTER_CONSUMER_KEY']
          config.consumer_secret     = ENV['BOT_TWITTER_CONSUMER_SECRET']
          config.access_token        = ENV['BOT_TWITTER_ACCESS_TOKEN']
          config.access_token_secret = ENV['BOT_TWITTER_ACCESS_TOKEN_SECRET']
        end
      end
    end
  end
end
