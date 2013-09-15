Chef::Log.info("Should configure matchmaker")

node[:opsworks][:layers][:mongo][:instances].each do |instance_name, instance|
	Chef::Log.info("Found MongoDB instance #{instance_name} at #{instance[:private_ip]}")
end

node[:opsworks][:layers][:rabbitmq][:instances].each do |instance_name, instance|
	Chef::Log.info("Found RabbitMQ instance #{instance_name} at #{instance[:private_ip]}")
end
