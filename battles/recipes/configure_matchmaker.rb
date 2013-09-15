Chef::Log.info("Should configure matchmaker")

deploy = node[:deploy][:matchmaker]

template "#{deploy[:deploy_to]}/current/matchmaker/matchmaker.cfg" do
	source 'matchmaker.cfg.erb'
	mode '0660'
	owner deploy[:user]
	group deploy[:group]
	variables(
		:mongodbhost => mongodbhost, 
		:memcachedhost => memcachedhost, 
		:rabbitmqhost => rabbitmqhost
	)
end


