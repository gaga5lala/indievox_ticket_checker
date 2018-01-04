require_relative "./notifier/telegram.rb"

require "date"

template = {
  作者: "gaga5lala",
  標題: "又當韭菜了 QQ",
  發文時間: DateTime.now.strftime("%Y/%m/%d %H:%M"),
  網址: "https://google.com",
}
template = {
  作者: "rmp41102",
  標題: "[請益] 請問大大都怎麼設停利點？",
  發文時間: "2018/01/04 10:17:12",
  網址: "https://www.ptt.cc/bbs/Stock/M.1515032235.A.D5B.html",
}

IFS="\n"

message = template.map{|k,v| "#{k}: #{v}"}.join(IFS)

Notifier::Telegram.new.create(message)
