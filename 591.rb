# TODO
# 1. health check
require 'rubygems'
require 'rest-client'
require 'json'
require_relative './notifier/telegram.rb'

# Options reference
# https://github.com/neighborhood999/fiveN1-rent-scraper#urljumpip-code-list
CONDITIONS = {
    'is_new_list': '1',
    'type': '1', # 類型???
    'kind': '1', # 類型
    'region': '1', # 位置：台北市
    'section': '4,3,5,7,1', # 區域：中山大安信義中正松山
    'searchtype': '1',
    'regionid': '1',
    'rentprice': '0,36000', # 租金
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

houses = result["data"]["data"]

newest_house_updated_at = File.read("newest_house_updated_at").to_i

count = 0
houses.each do |house|
  next if house["updatetime"] <= newest_house_updated_at

  message = {
    封面圖: house["cover"],
    標題: house["address_img_title"],
    網址: DETAIL_URL.gsub("{house_id}",house["id"].to_s),
    價錢: house["price"] + house["unit"],
    區域: house["region_name"] + house["section_name"],
    地址: house["fulladdress"],
    格局: house["layout"],
    坪數: house["area"],
    樓層: house["floorInfo"],
    房東提供: house["condition"],
    更新時間: Time.at(house["updatetime"]).to_datetime.to_s
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
  newest_house_updated_at = houses[0]["updatetime"]
  File.write('newest_house_updated_at', newest_house_updated_at)
end
