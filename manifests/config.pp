# == Class: squid::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
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
#   class { 'squid::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Michal Nowak <mailto:michal@casanowak.com>
#
class squid::config {

  #### Configuration

  # set params: in operation
  if $squid::ensure == 'present' {
    $config_ensure = 'present'
  # set params: removal
  } else {
    $config_ensure = 'absent'
  }

  # action
  file { $squid::params::config_path:
    ensure  => $config_ensure,
    mode    => $squid::params::config_mode,
    owner   => $squid::params::config_owner,
    group   => $squid::params::config_group,
    content => template($squid::template),
    notify  => Service[$squid::params::service],
  }
}
