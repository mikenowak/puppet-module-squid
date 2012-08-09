# == Class: squid::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'squid::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Michal Nowak <mailto:michal@casanowak.com>
#
class squid::package {

  #### Package management

  # set params: in operation
  if $squid::ensure == 'present' {
    $package_ensure = $squid::version
  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  # action
  package { $squid::params::package:
    ensure => $package_ensure,
  }
}
