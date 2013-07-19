require "pathname"

default[:cloudwatch][:hg_repo] = nil
default[:cloudwatch][:update_interval] = 2
default[:cloudwatch][:namespace] = node[:opsworks][:stack][:name]
default[:cloudwatch][:monitor_memcached] = node[:opsworks_custom_cookbooks][:recipes].include?('memcached')
default[:cloudwatch][:monitor_mongo] = node[:opsworks][:instance][:layers].include?('mongo')
default[:cloudwatch][:monitor_mem] = true
default[:cloudwatch][:disk_usage_paths] = node[:ebs][:devices].collect{|device_name, device| device[:mount_point]} rescue []
