if node[:deploy].attribute?(:matchmaker)

	Chef::Log.info("Should deploy matchmaker")
	Chef::Log.info("#{node[:deploy]}")

end