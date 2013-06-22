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

  file { "/etc/default/puppetmaster":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("puppet/etc_default_puppetmaster.erb"),
    require => Class["puppet::master::install"],
    notify  => Class["puppet::master::service"],
  }

  file { '/usr/local/bin/puppet-reports-stalker':
    content => template("puppet/puppet-reports-stalker.erb"),
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
  file { "/usr/lib/ruby/1.8/puppet/reports/foreman.rb":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("puppet/foreman/foreman.rb.erb"),
  }

  # Install the foreman push_facts.rb script + cronjob
  file { "/etc/puppet/foreman_push_facts.rb":
    owner   => puppet,
    group   => puppet,
    mode    => 555,
    content => template("puppet/foreman/push_facts.rb.erb"),
    ensure  => $puppet::master ? {
      default => "absent",
      true    => "present"
    },
  } -> cron { "send_facts_to_foreman":
    command => "/etc/puppet/foreman_push_facts.rb",
    user    => "puppet",
    minute  => "*/5",
    ensure  => $puppet::master ? {
      default => "absent",
      true    => "present"
    },
  }
}
