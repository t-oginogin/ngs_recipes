#
# Cookbook Name:: bowtie
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bowtie_user = node['bowtie']['user']
bowtie_dir = node['bowtie']['dir']
bowtie_ver = node['bowtie']['ver']

package 'unzip' do
  action :install
end

package 'python' do
  action :install
end

bash 'bowtie install' do
  user "#{bowtie_user}"

  not_if "test -e #{bowtie_dir}"

  code <<-EOL
    sudo mkdir -p #{bowtie_dir}
    sudo chown #{bowtie_user} -R #{bowtie_dir}
    sudo chgrp #{bowtie_user} -R #{bowtie_dir}
    cd #{bowtie_dir}
    wget http://cznic.dl.sourceforge.net/project/bowtie/bowtie/#{bowtie_ver}/bowtie-#{bowtie_ver}.tar.bz2
    wget http://sourceforge.net/projects/bowtie-bio/files/bowtie/#{bowtie_ver}/bowtie-#{bowtie_ver}-linux-x86_64.zip
    unzip bowtie-#{bowtie_ver}-linux-x86_64.zip
    cd bowtie-#{bowtie_ver}/
  EOL
end

file "/home/#{bowtie_user}/bowtie_path" do
  not_if "test -e /home/#{bowtie_user}/bowtie_path"
  user "#{bowtie_user}"
  group "#{bowtie_user}"
  content <<-EOL
    export PATH=#{bowtie_dir}/bowtie-#{bowtie_ver}/:$PATH
  EOL
  mode 0755
end

bash 'set bowtie path' do
  user "#{bowtie_user}"

  not_if "grep bowtie-#{bowtie_ver} /home/#{bowtie_user}/.bashrc"
  code <<-EOL
    cat /home/#{bowtie_user}/bowtie_path >> /home/#{bowtie_user}/.bashrc
    rm /home/#{bowtie_user}/bowtie_path
  EOL
end
