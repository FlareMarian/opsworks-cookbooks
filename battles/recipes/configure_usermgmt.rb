Chef::Log.info("Should configure usermgmt")

mongodbhost = nil
memcachedhost = nil
rabbitmqhost = nil

node[:opsworks][:layers][:mongo][:instances].each do |instance_name, instance|
	mongodbhost = instance[:private_ip]
	Chef::Log.info("Found MongoDB instance #{instance_name} at #{instance[:private_ip]}")
end

node[:opsworks][:layers][:rabbitmq][:instances].each do |instance_name, instance|
	rabbitmqhost = instance[:private_ip]
	Chef::Log.info("Found RabbitMQ instance #{instance_name} at #{instance[:private_ip]}")
end

node[:opsworks][:layers][:memcached][:instances].each do |instance_name, instance|
	memcachedhost = instance[:private_ip]
	Chef::Log.info("Found Memcached instance #{instance_name} at #{instance[:private_ip]}")
end

deploy = node[:deploy][:usermgmt]

service 'monit' do
	action :nothing
end

template "#{deploy[:deploy_to]}/current/usermgmt/usermgmt.cfg" do
	source 'backendservice.cfg.erb'
	mode '0660'
	owner deploy[:user]
	group deploy[:group]
	variables(
		:gameid => "battles_test",
		:serviceid => "usermgmt",
		:mongodbhost => mongodbhost, 
		:memcachedhost => memcachedhost, 
		:rabbitmqhost => rabbitmqhost
	)
end

template "/etc/monit/conf.d/usermgmt.monitrc" do
	source 'backendservice.monitrc.erb'
	owner 'root'
	group 'root'
	mode '0644'
	variables(
		:deploy => deploy,
		:serviceid => "usermgmt",
		:exefile => "UserManagement.exe"
	)
	notifies :restart, "service[monit]", :immediately
end

