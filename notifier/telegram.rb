require 'telegram/bot'
require 'dotenv/load'

IFS="\n"

module Notifier
  class Telegram
    def self.create(h)
      bot = ::Telegram::Bot::Client.new(ENV["TELEGRAM_TOKEN"])
      bot.api.send_message(chat_id: ENV["TELEGRAM_USER_ID"],
                           text: h.map{|k,v| "#{k}: #{v}"}.join(IFS))
    end
  end
end
