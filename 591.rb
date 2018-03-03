require 'rubygems'
require 'nokogiri'
require 'open-uri'
require_relative './notifier/telegram.rb'
require 'rest-client'
require 'json'

# Options reference
# https://github.com/neighborhood999/fiveN1-rent-scraper#urljumpip-code-list
CONDITIONS = {
    'is_new_list': '1',
    'type': '1', # 類型???
    'kind': '1', # 類型
    'searchtype': '1',
    'regionid': '1',
    'rentprice': '0,27500', # 租金
    'patternMore': '3,4', # 格局
    'option': 'cold', # 提供設備
    'other': 'cook', # 其他條件
    'hasimg': '1', # 有房屋圖片
    'not_cover': '1', # 排除頂樓加蓋
    'order': "posttime",
    'ordertype': "desc"
}

DETAIL_URL = "https://rent.591.com.tw/rent-detail-{house_id}.html"

url = ENV["591_SEARCH_URL"]
raise ArgumentError, "591_SEARCH_URL is missing." if url.nil?

RestClient.log = 'stdout'

response = RestClient.get(
  url,
  {params: CONDITIONS}.merge({cookies: {urlJumpIp: "1"}}
))

result = JSON.parse(response)
houses = result["data"]["data"]# ["data"][0]

Notifier::Telegram.create(
  {
    搜尋時間: Time.now,
    總件數: result["records"]
  }
)

houses[0..1].each do |house|
  message = {
    封面圖: house["cover"],
    標題: house["address_img_title"],
    網址: DETAIL_URL.gsub("{house_id}",house["id"].to_s),
    價錢: house["price"] + house["unit"],
    地址: house["fulladdress"],
    樓層: house["floor"],
  }

  Notifier::Telegram.create(message)
end
