# Cookbook Name:: modularit-webstack
# Recipe:: php-fpm
#
# Copyright 2013, CanaryTek
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Stack for multiversion PHP FPM

# Attributes used in recipe
build_deps = node['modularit-webstack']['php-fpm']['build_deps']
build_opts = node['modularit-webstack']['php-fpm']['build_opts']
pear_pkgs = node['modularit-webstack']['php-fpm']['pear_pkgs']
pecl_pkgs = node['modularit-webstack']['php-fpm']['pecl_pkgs']
download_url = node['modularit-webstack']['php-fpm']['download_url']
php_versions = node['modularit-webstack']['php-fpm']['php_versions']
install_prefix = node['modularit-webstack']['php-fpm']['install_prefix'] 

# Required packages to compile php
build_deps.each do |pkg|
  package pkg do
    action :install
  end
end

## Install each php version
php_versions.each do |ver|
  
  # Download php source file
  remote_file "#{Chef::Config[:file_cache_path]}/php-#{ver}.tar.bz2" do
    file="#{download_url}/php-#{ver}.tar.bz2"
    Chef::Log.info("Downloading #{file}")
    source file
    action :create_if_missing
  end

  # Compile and install php
  bash "install-php-#{ver}" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      rm -rf php-#{ver}
      tar xvjf php-#{ver}.tar.bz2
      cd php-#{ver}
      mkdir -p #{install_prefix}/php-#{ver}/etc/php.d
      ./configure --prefix=#{install_prefix}/php-#{ver} --with-config-file-path=#{install_prefix}/php-#{ver}/etc \
                  --with-config-file-scan-dir=#{install_prefix}/php-#{ver}/etc/php.d #{build_opts}
      make
      #make test
      make install
      cp php.ini-production #{install_prefix}/php-#{ver}/etc/php.ini
    EOH
    creates "#{install_prefix}/php-#{ver}/bin/php"
  end

  # Install pear packages
  pear_pkgs.each do |pkg|
    execute "install-php-#{ver}-pear-#{pkg}" do
      command "#{install_prefix}/php-#{ver}/bin/pear install #{pkg}"
      not_if "#{install_prefix}/php-#{ver}/bin/pear list #{pkg}"
    end
  end

  # Install pecl packages
  pecl_pkgs.each do |pkg|
    execute "install-php-#{ver}-pecl-#{pkg}" do
      command "#{install_prefix}/php-#{ver}/bin/pecl install #{pkg}"
      not_if "#{install_prefix}/php-#{ver}/bin/pecl list #{pkg}"
    end
  end

  # php-fpm config
  template "/opt/php/php-#{ver}/etc/php-fpm.conf" do
    source "php-fpm_conf.erb"
    mode  00644
    action :create
  end
  # pool.d dir and default pool
  directory "/opt/php/php-#{ver}/etc/pool.d" do
    action :create
  end
  template "/opt/php/php-#{ver}/etc/pool.d/default.conf" do
    source "php-fpm_default_pool.erb"
    mode  00644
    action :create
    variables(
      :php_version => ver
    )
  end
  # Socket directory
  directory "/var/run/php-#{ver}-fpm" do
    action :create
  end

  # SysV init script
  template "/etc/init.d/php-#{ver}-fpm" do
    source "php-fpm_init.erb"
    mode  00755
    action :create
    variables(
      :php_version => ver
    )
  end
  # php-fpm service
  service "php-#{ver}-fpm" do
    action [:start, :enable]
  end
end

# Sample nginx site
template "/etc/nginx/conf.d/sample-site.conf.sample" do
  source "nginx-001-sample-site.erb"
  mode  00644
  action :create
end
