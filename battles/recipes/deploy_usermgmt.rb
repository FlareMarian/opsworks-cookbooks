include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  Chef::Log.info("Incoming deploy for #{application}")

  if application != 'usermgmt'
    Chef::Log.debug("Skipping deploy for application #{application} as it is not a usermgmt")
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
  
  include_recipe 'battles::configure_usermgmt'

  ruby_block "restart usermgmt application #{application}" do
    block do
      Chef::Log.info(`monit restart usermgmt`)
    end
  end
end
