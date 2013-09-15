
set[:mongodbhost] = nil
set[:memcachedhost] = nil
set[:rabbitmqhost] = nil

node[:opsworks][:layers][:mongo][:instances].each do |instance_name, instance|
	set[:mongodbhost] = instance[:private_ip]
end

node[:opsworks][:layers][:rabbitmq][:instances].each do |instance_name, instance|
	set[:rabbitmqhost] = instance[:private_ip]
end

node[:opsworks][:layers][:memcached][:instances].each do |instance_name, instance|
	set[:memcachedhost] = instance[:private_ip]
end

