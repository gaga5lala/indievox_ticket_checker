# TODO
# 1. health check
require 'rubygems'
require 'rest-client'
require 'json'
require 'yaml'
require_relative './notifier/telegram.rb'
CONFIG = YAML::load_file(File.join(__dir__, 'config', '591.yml'))

url = ENV["591_SEARCH_URL"]
raise ArgumentError, "591_SEARCH_URL is missing." if url.nil?

logger = Logger.new('./591.log')
logger.level = Logger::DEBUG
logger << "Execute at: #{Time.now.to_s}\n"
RestClient.log = logger

response = RestClient.get(
  url,
  {params: CONFIG["CONDITIONS"]}.merge({cookies: {urlJumpIp: "1"}}
))

result = JSON.parse(response)

houses = result["data"]["data"]

newest_house_updated_at = File.read("newest_house_updated_at").to_i

count = 0
houses.each do |house|
  next if house["refreshtime"] <= newest_house_updated_at

  message = {
    標題: house["address_img_title"],
    價錢: house["price"] + house["unit"],
    區域: house["region_name"] + house["section_name"],
    封面圖: house["cover"],
    網址: CONFIG["DETAIL_URL"].gsub("{house_id}",house["id"].to_s),
    地址: house["fulladdress"],
    格局: house["layout"],
    坪數: house["area"],
    樓層: house["floorInfo"],
    房東提供: house["condition"],
    默認更新時間: Time.at(house["refreshtime"]).to_datetime.to_s
  }

  Notifier::Telegram.create(message)

  count += 1
end

if count > 0
  Notifier::Telegram.create(
    {
      符合條件筆數: count,
      搜尋時間: Time.now,
    }
  )
  newest_house_updated_at = houses[0]["refreshtime"]
  File.write('newest_house_updated_at', newest_house_updated_at)
end
