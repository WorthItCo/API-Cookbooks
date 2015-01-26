node[:deploy].each do |application, deploy|

  Chef::Log.info("Configuring crawler Cron for application #{application}")

  cron "restart-crawlers" do
    minute 10
    hour "*"
    command "service crawler-#{application} stop; service crawler-productsapi start"
  end
end