#
# Cookbook Name:: bwa
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bwa_user = node['bwa']['user']
bwa_dir = node['bwa']['dir']
bwa_ver = node['bwa']['ver']

package 'bzip2' do
  action :install
end

bash 'bwa install' do
  user "#{bwa_user}"

  not_if 'which bwa'

  code <<-EOL
    sudo mkdir -p #{bwa_dir}
    sudo chown #{bwa_user} -R #{bwa_dir}
    sudo chgrp #{bwa_user} -R #{bwa_dir}
    cd #{bwa_dir}
    wget http://jaist.dl.sourceforge.net/project/bio-bwa/bwa-#{bwa_ver}.tar.bz2
    bzip2 -dc bwa-#{bwa_ver}.tar.bz2 | tar xvf -
    cd bwa-#{bwa_ver}/
    make
  EOL
end

bash 'set bwa path' do
  user "#{bwa_user}"

  not_if "grep bwa /home/#{bwa_user}/.bashrc"

  code <<-EOL
    echo "export PATH=#{bwa_dir}/bwa-#{bwa_ver}/:$PATH" >> /home/#{bwa_user}/.bashrc
  EOL
end
