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
		ensure => file,
		owner  => root,
		group  => root,
		mode   => 0644,
		content => template("puppet/etc_default_puppetmaster.erb"),
		require => Class["puppet::master::install"],
		notify => Class["puppet::master::service"],
	}

  file { '/usr/local/bin/puppet-reports-stalker':
    content => template("puppet/puppet-reports-stalker.erb"),
    mode   =>  755,
    owner  =>  root,
    group  =>  root,
  } ->
  cron { 'puppet clean reports':
    command =>  '/usr/local/bin/puppet-reports-stalker',
    user =>  root,
    hour =>  21,
    minute =>  22,
    weekday =>  0,
  }
}
