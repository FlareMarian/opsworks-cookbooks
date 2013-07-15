include_recipe "flarebook::update_gameserver_config"

deploy = node[:deploy][:gameserver]
application = :gameserver

link "#{deploy[:deploy_to]}/current/src/nodejs/config.json" do
  	to "#{deploy[:deploy_to]}/shared/config/gameserver_config.json"
end

link "#{deploy[:deploy_to]}/current/src/nodejs/log/" do
  	to "#{deploy[:deploy_to]}/shared/log/"
end

ruby_block "restart node.js application #{application}" do
	block do
		if deploy[:auto_npm_install_on_deploy]
			OpsWorks::NodejsConfiguration.npm_install(application, node[:deploy][application], "#{deploy[:deploy_to]}/current/src/nodejs")
		end
		Chef::Log.info("restart node.js via: #{node[:deploy][application][:nodejs][:restart_command]}")
		Chef::Log.info(`#{node[:deploy][application][:nodejs][:restart_command]}`)
		$? == 0
	end	
end
