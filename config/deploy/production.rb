# This is the setup for the EC2 setup
server '52.203.103.24', user: 'ubuntu', roles: %w{app db web}

# including the deploy_to setting here in case we want to change it at this server
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"