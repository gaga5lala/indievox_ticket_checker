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
