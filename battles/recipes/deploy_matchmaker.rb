include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  Chef::Log.info("Incoming deploy for #{application}")

  if application != 'matchmaker'
    Chef::Log.debug("Skipping deploy for application #{application} as it is not a matchmaker")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  include_recipe 'battles::configure_matchmaker'

  ruby_block "restart matchmaker application #{application}" do
    block do
      Chef::Log.info(`monit restart matchmaker`)
    end
  end
end
