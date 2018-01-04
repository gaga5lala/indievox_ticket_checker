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

url = 'https://www.ptt.cc/bbs/Stock/index3920.html'

doc = Nokogiri::HTML(open(url))

doc.css('r-list-container').css('ent')

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

