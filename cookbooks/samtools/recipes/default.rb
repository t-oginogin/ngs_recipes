#
# Cookbook Name:: samtools
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

samtools_user = node['samtools']['user']
samtools_dir = node['samtools']['dir']
samtools_ver = node['samtools']['ver']

package 'bzip2' do
  action :install
end

package 'libncurses5-dev' do
  action :install
end

bash 'samtools install' do
  user "#{samtools_user}"

  not_if "test -e #{samtools_dir}"

  code <<-EOL
    sudo mkdir -p #{samtools_dir}
    sudo chown #{samtools_user} -R #{samtools_dir}
    sudo chgrp #{samtools_user} -R #{samtools_dir}
    cd #{samtools_dir}
    wget http://cznic.dl.sourceforge.net/project/samtools/samtools/#{samtools_ver}/samtools-#{samtools_ver}.tar.bz2
    bzip2 -dc samtools-#{samtools_ver}.tar.bz2 | tar xvf -
    cd samtools-#{samtools_ver}/
    make
  EOL
end

file "/home/#{samtools_user}/samtools_path" do
  not_if "test -e /home/#{samtools_user}/samtools_path"
  user "#{samtools_user}"
  group "#{samtools_user}"
  content <<-EOL
    export PATH=#{samtools_dir}/samtools-#{samtools_ver}/:$PATH
  EOL
  mode 0755
end

bash 'set samtools path' do
  user "#{samtools_user}"

  not_if "grep samtools /home/#{samtools_user}/.bashrc"
  code <<-EOL
    cat /home/#{samtools_user}/samtools_path >> /home/#{samtools_user}/.bashrc
    rm /home/#{samtools_user}/samtools_path
  EOL
end

