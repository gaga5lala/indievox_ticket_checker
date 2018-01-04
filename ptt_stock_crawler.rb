require 'rubygems'
require 'nokogiri'
require 'open-uri'

# 1. fetch index page
# 2. iterator until timestamp < previous_visit_at
#   * r-list-container > r-ent
#   mata > author == {AUTHOR}
# 3. return object include
#   * title
#   * url
#   * readable_time

base_url = "https://www.ptt.cc"
location = '/bbs/Stock/index.html'

# note 302 found
doc = Nokogiri::HTML(open(base_url + location))

articles = doc.css('.r-list-container .r-ent')
articles.each do |article|
  list.first.css('.title a').first.attributes['href'].value

end

posts.each do |post|
  if match_condition
    Notifier::Telegram.new.create(message)
  end
end

# next page
# action-bar-container > action-bar > btn-group btn-group-paging [1] "上頁"

private

def match_condition(post)
  subscribed_authors.include? post.author || subscribed_titles.include? post.title
end

def template()
template = {
  作者: "rmp41102",
  標題: "[請益] 請問大大都怎麼設停利點？",
  發文時間: "2018/01/04 10:17:12",
  網址: "https://www.ptt.cc/bbs/Stock/M.1515032235.A.D5B.html",
}
end
