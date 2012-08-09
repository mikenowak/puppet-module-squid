# == Class: squid::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Michal Nowak <mailto:michal@casanowak.com>
#
class squid::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # version
  $version = 'present'

  # service status
  $status = 'enabled'

  # template file
  $template = 'squid/squid.conf.erb'

  # options
  $options = ''

  # acl_src
  $acl_src = { 'any' => '0.0.0.0/0' }


  #### Internal module values

  # packages
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora': {
      $package = [ 'squid' ]
    }
    'Debian', 'Ubuntu': {
      $package = [ 'squid' ]
    }
    default: {
      fail("\"${module_name}\" provides no package default value for \"${::operatingsystem}\"")
    }
  }

  # config parameters
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora': {
      $config_path        = '/etc/squid/squid.conf'
      $config_mode        = '0600'
      $config_owner       = 'root'
      $config_group       = 'root'
    }
    'Debian', 'Ubuntu': {
      $config_path        = '/etc/squid/squid.conf'
      $config_mode        = '0600'
      $config_owner       = 'root'
      $config_group       = 'root'
    }
    default: {
      fail("\"${module_name}\" provides no config parameters for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora': {
      $service            = 'squid'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service
    }
    'Debian', 'Ubuntu': {
      $service            = 'squid'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service
    }
    default: {
      fail("\"${module_name}\" provides no service parameters for \"${::operatingsystem}\"")
    }
  }
}
