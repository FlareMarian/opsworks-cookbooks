Chef::Log.info("Should configure turnserver")

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

deploy = node[:deploy][:matchmaker]

service 'monit' do
	action :nothing
end

template "#{deploy[:deploy_to]}/current/webnodejs/src/nodejs/config.js" do
	source 'turnserverconfig.js.erb'
	mode '0660'
	owner deploy[:user]
	group deploy[:group]
	variables(
		:gameid => "battles_test",
		:mongodbhost => mongodbhost, 
		:memcachedhost => memcachedhost, 
		:rabbitmqhost => rabbitmqhost
	)
end

template "/etc/monit/conf.d/turnserver.monitrc" do
	source 'turnserver.monitrc.erb'
	owner 'root'
	group 'root'
	mode '0644'
	variables(
		:deploy => deploy
	)
	notifies :restart, "service[monit]", :immediately
end

