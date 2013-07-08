# Class: puppet::foreman::config
#
# This class manage the foreman configuration
class puppet::foreman::config {
  file { '/etc/default/foreman':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('puppet/foreman/etc_default_foreman.erb'),
    require => Class['puppet::foreman::install'],
    notify  => Class['puppet::foreman::service'],
  }
}
