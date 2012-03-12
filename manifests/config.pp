# Class: puppet::config
#
# This class manage the puppet configuration
class puppet::config {
	
	# configure agent daemon/service to start at boot time or not
	case $::operatingsystem {
		/(Ubuntu|Debian)/: {
			file { "/etc/default/puppet":
				ensure => file,
				owner  => root,
				group  => root,
				mode   => 0644,
				content => template("puppet/etc_default_puppet.erb"),
				require => Class["puppet::install"],
				notify => Class["puppet::service"],
			}
		}
		default: {
			fail ("The ${module_name} module is not supported on $::operatingsystem")
		}
	}
	
	if ( $puppet::master == true ) {
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
			require => Class["puppet::install"],
			notify => Class["puppet::service"],
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
	
	# TODO finish to implement Puppet Dashboard Configuration
	if ( $puppet::dashboard == true ) {
		file { "/etc/default/puppet-dashboard":
			ensure => file,
			owner  => root,
			group  => root,
			mode   => 0644,
			content => template("puppet/etc_default_puppet-dashboard.erb"),
			require => Class["puppet::install"],
			notify => Class["puppet::service"],
		}
		file { "/etc/default/puppet-dashboard-workers":
			ensure => file,
			owner  => root,
			group  => root,
			mode   => 0644,
			content => template("puppet/etc_default_puppet-dashboard-workers.erb"),
			require => Class["puppet::install"],
			notify => Class["puppet::service"],
		}
	}
	
	# puppet agent and master configuration file
	file { $puppet::params::config_file:
		ensure => file,
		owner  => root,
		group  => root,
		mode   => 0644,
		content => template("puppet/$puppet::params::config_template"),
		require => [Class["puppet::install"], File["/etc/default/puppet"]],
		notify => Class["puppet::service"],
	}
	
}
