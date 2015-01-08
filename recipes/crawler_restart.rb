node[:deploy].each do |application, deploy|
  service "crawler-#{application}" do
    action [:stop, :start]
    provider Chef::Provider::Service::Upstart
  end
end
