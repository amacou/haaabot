require 'open-uri'

module Ruboty
  module Handlers
    class Haaabot < Base
      on(
        /はー…[[:blank:]]*(?<keyword>.+)/,
        name: 'haaa',
        all: true,
        description: 'はー…のあとの文字を検索します'
      )

      def haaa(message)
        if url = search(message[:keyword])
          text = "#{message[:keyword]}？ #{url}"
          bot.update_with_media(text, open(url))
        end
      end

      private

      def search(query)
        Ruboty::GoogleImage::Client.new(query: query).get
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
