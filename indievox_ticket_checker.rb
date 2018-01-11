require 'rubygems'
require 'nokogiri'
require 'open-uri'
require_relative './notifier/telegram.rb'

url = ENV["INDIEVOX_EVENT_URL"]
raise ArgumentError, "INDIEVOE_EVENT_URL is missing." if url.nil?

doc = Nokogiri::HTML(open(url))

message = {
  購票狀態: "可購買！",
  活動名稱: doc.css('title').text,
  網址: url,
  checked_at: Time.now.getlocal('+08:00')
}

# 已售完: disabled=disabled
# 可購買: nil
available = !doc.css('.event-block.m-bottom-2 button').first.attributes['disabled']

if available
  Notifier::Telegram.create(message)
end
