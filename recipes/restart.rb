node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping opsworks-resque::restart application #{application} as it is not a Rails app")
    next
  end

  service "resque-#{application}" do
    action [:stop, :start]
    provider Chef::Provider::Service::Upstart
  end
end
