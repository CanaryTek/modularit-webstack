#
# Author:: Kuko Armas
# Cookbook Name:: modularit-webstack
# Attribute:: php-fpm
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
#

## Atributes for php-fpm stack

# PHP build options
default['modularit-webstack']['php-fpm']['build_opts'] = "--disable-posix --with-pgsql --with-pdo-pgsql --with-zlib --with-gd --with-openssl --with-curl --with-zlib --with-iconv --with-bz2 --with-gettext --with-fpm-user=nginx --with-fpm-group=nginx --enable-ftp --with-gettext --enable-fpm --with-mcrypt --enable-mbstring --enable-opcache --enable-bcmath --enable-calendar --enable-soap --enable-sockets --enable-zip --with-snmp"

# Build dependencies
case node['platform_family']
when 'debian'
  default['modularit-webstack']['php-fpm']['build_deps'] = %w[PLEASE_DEFINE]
when 'rhel','fedora'
  default['modularit-webstack']['php-fpm']['build_deps'] = %w[bzip2 gcc libxml2-devel postgresql-devel openssl-devel bzip2-devel libcurl-devel gd-devel libmcrypt-devel net-snmp-devel libssh2-devel]
else
  default['modularit-webstack']['php-fpm']['build_deps'] = %w[PLEASE_DEFINE]
end
# Additional pear packages
default['modularit-webstack']['php-fpm']['pear_pkgs'] = %w[]
# Additional pecl packages
default['modularit-webstack']['php-fpm']['pecl_pkgs'] = %w[]
# PHP download URL
default['modularit-webstack']['php-fpm']['download_url'] = "http://es1.php.net/distributions"
# PHP versions to install
default['modularit-webstack']['php-fpm']['php_versions'] = %w[5.4.45 5.5.30 5.6.14]
# PHP install prefix
default['modularit-webstack']['php-fpm']['install_prefix'] = "/opt/php"

build_opts="--disable-posix --with-pgsql --with-pdo-pgsql --with-zlib --with-gd --with-openssl --with-curl --with-zlib --with-iconv --with-bz2 --with-gettext --with-fpm-user=nginx --with-fpm-group=nginx --enable-ftp --with-gettext --enable-fpm --with-mcrypt --enable-mbstring --enable-opcache --enable-bcmath --enable-calendar --enable-soap --enable-sockets --enable-zip --with-snmp"

