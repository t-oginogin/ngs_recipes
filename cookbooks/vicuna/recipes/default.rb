#
# Cookbook Name:: vicuna
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

vicuna_user = node['vicuna']['user']
vicuna_dir = node['vicuna']['dir']
vicuna_ver = node['vicuna']['ver']

bash 'vicuna unzip' do
  user "#{vicuna_user}"

  not_if "test -e #{vicuna_dir}"

  code <<-EOL
    sudo mkdir -p #{vicuna_dir}
    sudo chown #{vicuna_user} -R #{vicuna_dir}
    sudo chgrp #{vicuna_user} -R #{vicuna_dir}
    cd #{vicuna_dir}
    cp /ngs/tmp/vicuna.zip .
    unzip vicuna.zip
  EOL
end

template "#{vicuna_dir}/VICUNA_v#{vicuna_ver}/src/Makefile" do
  source 'Makefile.erb'
  owner "#{vicuna_user}"
  group "#{vicuna_user}"
  mode 0755 
  
  variables ({
    :ncbi_cxx_dir     => node['vicuna']['ncbi_cxx_dir'],
  })
end

bash 'vicuna install' do
  user "#{vicuna_user}"

  not_if "test -e #{vicuna_dir}/VICUNA_v#{vicuna_ver}/bin"

  code <<-EOL
    cd #{vicuna_dir}/VICUNA_v#{vicuna_ver}/src/
    make
    sudo chown #{vicuna_user} -R #{vicuna_dir}
    sudo chgrp #{vicuna_user} -R #{vicuna_dir}
  EOL
end

file "/home/#{vicuna_user}/vicuna_path" do
  not_if "test -e /home/#{vicuna_user}/vicuna_path"
  user "#{vicuna_user}"
  group "#{vicuna_user}"
  content <<-EOL
    export PATH=#{vicuna_dir}/VICUNA_v#{vicuna_ver}/bin/:$PATH
  EOL
  mode 0755
end

bash 'set vicuna path' do
  user "#{vicuna_user}"

  not_if "grep VICUNA_v#{vicuna_ver} /home/#{vicuna_user}/.bashrc"
  code <<-EOL
    cat /home/#{vicuna_user}/vicuna_path >> /home/#{vicuna_user}/.bashrc
    rm /home/#{vicuna_user}/vicuna_path
  EOL
end
