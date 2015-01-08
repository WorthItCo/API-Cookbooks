#
# Cookbook Name:: products_chef
# Recipe:: crawler_setup
#
# Copyright (C) 2014 PEDRO AXELRUD
#
# All rights reserved - Do Not Redistribute
#

node[:deploy].each do |application, deploy|

  Chef::Log.info("Configuring crawler for application #{application}")

  template "/etc/init/crawler-#{application}.conf" do
    source "crawler.conf.erb"
    mode '0644'
    variables deploy: deploy
  end

  settings = node[:frys_crawler][application]
  # configure rails_env in case of non-rails app
  rack_env = deploy[:rails_env] || settings[:rack_env] || settings[:rails_env]
  settings[:frys_crawlers].each do |quantity|

    quantity.times do |idx|
      idx = idx + 1 # make index 1-based
      template "/etc/init/frys-crawler-#{application}-#{idx}.conf" do
        source "site-crawler-n.conf.erb"
        mode '0644'
        variables application: application, site: 'frys', rack_env: rack_env, deploy: deploy, instance: idx
      end
    end
  end
end