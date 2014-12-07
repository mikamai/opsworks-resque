#
# Cookbook Name:: opsworks-resque
# Recipe:: default
#
# Copyright (C) 2014 PEDRO AXELRUD
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init/resque.conf" do
  source "resque.conf.erb"
  mode "0755"
end

node[:deploy].each do |application, deploy|

  Chef::Log.info("Configuring resque for application #{application}")

  settings = node[:resque][application]
  settings[:workers].each do |queue, quantity|

    quantity.times do |idx|
      idx = idx + 1 # make index 1-based
      
      Chef::Log.info("Configuring resque for #{queue} with #{quantity} workers (idx #{idx})")
      
      template "/etc/init/resque-#{idx}.conf" do
        source "resque-n.conf.erb"
        mode "0755"
        variables deploy: deploy, queue: queue, instance: idx
      end
    end
  end
end