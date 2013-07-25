# Class: puppet::config
#
# This class manage the puppet configuration
class puppet::config {
  # configure agent daemon/service to start at boot time or not
  case $::operatingsystem {
    /(Ubuntu|Debian)/ : {
      file { '/etc/default/puppet':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => 0644,
        content => template('puppet/etc_default_puppet.erb'),
        require => Class['puppet::install'],
        notify  => Class['puppet::service'],
      }
    }
    default           : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }

  if ($puppet::master == true) {
    include puppet::master::config
  }

  if ($puppet::dashboard == true) {
    include puppet::dashboard::config
  }

  if ($puppet::foreman == true) {
    include puppet::foreman::config
  }

  # puppet agent and master configuration file
  file { $puppet::params::config_file:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("puppet/${puppet::params::config_template}"),
    require => [
      Class['puppet::install'],
      File['/etc/default/puppet']],
    notify  => Class['puppet::service'],
  }
  file { $puppet::params::auth_file:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("puppet/${puppet::params::auth_template}"),
    require => [
      Class['puppet::install'],
      File['/etc/default/puppet']],
    notify  => Class['puppet::service'],
  }

}
