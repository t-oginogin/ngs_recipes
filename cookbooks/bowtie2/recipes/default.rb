#
# Cookbook Name:: bowtie2
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bowtie2_user = node['bowtie2']['user']
bowtie2_dir = node['bowtie2']['dir']
bowtie2_ver = node['bowtie2']['ver']

package 'unzip' do
  action :install
end

bash 'bowtie2 install' do
  user "#{bowtie2_user}"

  not_if "test -e #{bowtie2_dir}/bowtie2-#{bowtie2_ver}"

  code <<-EOL
    sudo mkdir -p #{bowtie2_dir}
    sudo chown #{bowtie2_user} -R #{bowtie2_dir}
    sudo chgrp #{bowtie2_user} -R #{bowtie2_dir}
    cd #{bowtie2_dir}
    wget http://sourceforge.net/projects/bowtie-bio/files/bowtie2/#{bowtie2_ver}/bowtie2-#{bowtie2_ver}-linux-x86_64.zip
    unzip bowtie2-#{bowtie2_ver}-linux-x86_64.zip
    cd bowtie2-#{bowtie2_ver}/
  EOL
end

file "/home/#{bowtie2_user}/bowtie2_path" do
  not_if "test -e /home/#{bowtie2_user}/bowtie2_path"
  user "#{bowtie2_user}"
  group "#{bowtie2_user}"
  content <<-EOL
    export PATH=#{bowtie2_dir}/bowtie2-#{bowtie2_ver}/:$PATH
  EOL
  mode 0755
end

bash 'set bowtie2 path' do
  user "#{bowtie2_user}"

  not_if "grep bowtie2-#{bowtie2_ver} /home/#{bowtie2_user}/.bashrc"
  code <<-EOL
    cat /home/#{bowtie2_user}/bowtie2_path >> /home/#{bowtie2_user}/.bashrc
    rm /home/#{bowtie2_user}/bowtie2_path
  EOL
end
