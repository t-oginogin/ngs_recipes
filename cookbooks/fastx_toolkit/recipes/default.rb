#
# Cookbook Name:: fastx_toolkit
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

fastx_toolkit_user = node['fastx_toolkit']['user']
fastx_toolkit_dir = node['fastx_toolkit']['dir']
fastx_toolkit_ver = node['fastx_toolkit']['ver']

package 'pkg-config' do
  action :install
end

bash 'fastx_toolkit install' do
  user "#{fastx_toolkit_user}"

  not_if "test -e #{fastx_toolkit_dir}/fastx_toolkit-#{fastx_toolkit_ver}"

  code <<-EOL
    sudo mkdir -p #{fastx_toolkit_dir}
    sudo chown #{fastx_toolkit_user} -R #{fastx_toolkit_dir}
    sudo chgrp #{fastx_toolkit_user} -R #{fastx_toolkit_dir}
    cd #{fastx_toolkit_dir}
    wget wget https://github.com/agordon/libgtextutils/releases/download/0.7/libgtextutils-0.7.tar.gz
    tar -xvzf libgtextutils-0.7.tar.gz
    cd libgtextutils-0.7
    ./configure
    make
    sudo make install

    wget https://github.com/agordon/fastx_toolkit/releases/download/0.0.14/fastx_toolkit-0.0.14.tar.bz2 
    tar -xjf fastx_toolkit-#{fastx_toolkit_ver}.tar.bz2
    cd fastx_toolkit-#{fastx_toolkit_ver}/
    ./configure
    make
    sudo make install
  EOL
end

file "/home/#{fastx_toolkit_user}/fastx_toolkit_path" do
  not_if "test -e /home/#{fastx_toolkit_user}/fastx_toolkit_path"
  user "#{fastx_toolkit_user}"
  group "#{fastx_toolkit_user}"
  content <<-EOL
    export PATH=#{fastx_toolkit_dir}/fastx_toolkit-#{fastx_toolkit_ver}/:$PATH
  EOL
  mode 0755
end

bash 'set fastx_toolkit path' do
  user "#{fastx_toolkit_user}"

  not_if "grep fastx_toolkit-#{fastx_toolkit_ver} /home/#{fastx_toolkit_user}/.bashrc"
  code <<-EOL
    cat /home/#{fastx_toolkit_user}/fastx_toolkit_path >> /home/#{fastx_toolkit_user}/.bashrc
    rm /home/#{fastx_toolkit_user}/fastx_toolkit_path
  EOL
end
