require "rufus-scheduler"

scheduler = Rufus::Scheduler.new

scheduler.every '5m' do
  puts "Indievox ticker checker run at #{Time.now}"
  system "ruby indievox_ticket_checker.rb"
end

scheduler.join
