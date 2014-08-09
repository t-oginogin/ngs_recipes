#
# Cookbook Name:: ncbi_tools
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ncbi_tools_user = node['ncbi_tools']['user']
ncbi_tools_dir = node['ncbi_tools']['dir']
ncbi_tools_install_dir = node['ncbi_tools']['install_dir']
ncbi_tools_ver = node['ncbi_tools']['ver']

package 'libbam-dev' do
  action :install
end

bash 'download ncbi_tools' do
  user "#{ncbi_tools_user}"

  not_if "test -e #{ncbi_tools_dir}/ncbi_cxx--#{ncbi_tools_ver}.tar.gz"
  code <<-EOL
    sudo mkdir -p #{ncbi_tools_dir}
    sudo chown #{ncbi_tools_user} -R #{ncbi_tools_dir}
    sudo chgrp #{ncbi_tools_user} -R #{ncbi_tools_dir}
    cd #{ncbi_tools_dir}
    wget ftp://ftp.ncbi.nih.gov:21/toolbox/ncbi_tools++/CURRENT/ncbi_cxx--12_0_0.tar.gz
  EOL
end

bash 'ncbi_tools install' do
  user "#{ncbi_tools_user}"

  not_if "test -e #{ncbi_tools_install_dir}/lib"

  code <<-EOL
    cd #{ncbi_tools_dir}
    tar xvzf ncbi_cxx--#{ncbi_tools_ver}.tar.gz
    cd ncbi_cxx--#{ncbi_tools_ver}/
    ./configure --prefix=#{ncbi_tools_install_dir}
    make > make_std_out.log 2> make_std_err.log
    sudo make install
    sudo chown #{ncbi_tools_user} -R #{ncbi_tools_install_dir}
    sudo chgrp #{ncbi_tools_user} -R #{ncbi_tools_install_dir}
  EOL
end

file "/home/#{ncbi_tools_user}/ncbi_tools_path" do
  not_if "test -e /home/#{ncbi_tools_user}/ncbi_tools_path"
  user "#{ncbi_tools_user}"
  group "#{ncbi_tools_user}"
  content <<-EOL
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH\:#{ncbi_tools_install_dir}/lib
  EOL
  mode 0755
end

bash 'set ncbi_tools path' do
  user "#{ncbi_tools_user}"

  not_if "grep ncbi /home/#{ncbi_tools_user}/.bashrc"
  code <<-EOL
    cat /home/#{ncbi_tools_user}/ncbi_tools_path >> /home/#{ncbi_tools_user}/.bashrc
    rm /home/#{ncbi_tools_user}/ncbi_tools_path
  EOL
end
