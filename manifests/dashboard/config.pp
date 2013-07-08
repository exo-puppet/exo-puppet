# Class: puppet::dashboard::config
#
# This class manage the puppet configuration
class puppet::dashboard::config {
  file { '/etc/default/puppet-dashboard':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('puppet/dashboard/etc_default_puppet-dashboard.erb'),
    require => Class['puppet::dashboard::install'],
    notify  => Class['puppet::dashboard::service'],
  } -> file { '/etc/default/puppet-dashboard-workers':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('puppet/dashboard/etc_default_puppet-dashboard-workers.erb'),
    require => Class['puppet::dashboard::install'],
    notify  => Class['puppet::dashboard::service'],
  } -> file { "${puppet::params::dashboard_home}/config/settings.yml":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('puppet/dashboard/settings.yml.erb'),
    require => Class['puppet::dashboard::install'],
    notify  => Class['puppet::dashboard::service'],
  } -> file { '/etc/puppet-dashboard/database.yml':
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    mode    => 0640,
    content => template('puppet/dashboard/etc_puppet-dashboard_database.yml.erb'),
    require => Class['puppet::dashboard::install'],
    notify  => [
      Exec['dashboard-database-migrate'],
      Class['puppet::dashboard::service']],
  }

  exec { 'dashboard-database-migrate':
    path        => $::path,
    cwd         => '/usr/share/puppet-dashboard/',
    command     => 'rake RAILS_ENV=production db:migrate',
    require     => [
      File['/etc/puppet-dashboard/database.yml']],
    refreshonly => true,
    notify      => [
      Service['puppet-dashboard'],
      Service['puppet-dashboard-workers']],
  }
}
