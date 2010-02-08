#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../init"

polling_interval = 60

#logger = Logger.new(Pathname(RAILS_ROOT) + "log" + "background.log")
#ActiveRecord::Base.logger = logger

Signal.trap("TERM") { exit }

loop do
  if video = Video.first(:state=>"request")
    print Time.now.strftime("%Y-%m-%d %H:%M:%S ")
    puts "processing Video(#{video.id}): #{video.url}"
    video.download!
  else
    print Time.now.strftime("%Y-%m-%d %H:%M:%S ")
    puts "nothing to do (waiting for #{polling_interval} sec)"
    sleep polling_interval
  end
end
