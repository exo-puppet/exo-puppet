# Class: puppet::config
#
# This class manage the puppet configuration
class puppet::master::config {
  file { $puppet::params::master_manifests_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0755,
  }

  file { $puppet::params::master_templates_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0755,
  }

  file { '/etc/default/puppetmaster':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('puppet/etc_default_puppetmaster.erb'),
    require => Class['puppet::master::install'],
    notify  => Class['puppet::master::service'],
  }

  file { '/usr/local/bin/puppet-reports-stalker':
    content => template('puppet/puppet-reports-stalker.erb'),
    mode    => 755,
    owner   => root,
    group   => root,
  } -> cron { 'puppet clean reports':
    command => '/usr/local/bin/puppet-reports-stalker',
    user    => root,
    hour    => 21,
    minute  => 22,
    weekday => 0,
  }

  # Install the foreman report
  exec { 'create-puppet-reports-dir':
    command => "/bin/mkdir -p ${$puppet::params::basedir}/reports",
    creates => "${puppet::params::basedir}/reports"
  }

  file { "${puppet::params::basedir}/reports/foreman.rb":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('puppet/foreman/foreman.rb.erb'),
    require => [
      Exec['create-puppet-reports-dir'],
      Class['puppet::master::install']],
  }

  # Install the foreman push_facts.rb script + cronjob
  file { '/etc/puppet/foreman_push_facts.rb':
    ensure  => $puppet::master ? {
      true    => 'present',
      default => 'absent',
    },
    owner   => puppet,
    group   => puppet,
    mode    => 555,
    content => template('puppet/foreman/push_facts.rb.erb'),
  } -> cron { 'send_facts_to_foreman':
    ensure  => $puppet::master ? {
      true    => 'present',
      default => 'absent',
    },
    command => '/etc/puppet/foreman_push_facts.rb',
    user    => 'puppet',
    minute  => '*/5',
  }
}
