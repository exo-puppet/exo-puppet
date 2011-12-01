# Class: puppet::service
#
# This class manage the puppet services
#
# TODO Split puppet::service in 2 other classes (puppet::service_master puppet::service_dashboard) to better manage Notify in puppet::config 
# 
class puppet::service {
	include "puppet::params"
	
	# Puppet Agent Service
	service { "puppet":
		ensure     => $puppet::params::agent_service_ensure,
		name       => $puppet::params::service_name,
		hasstatus  => true,
		hasrestart => true,
		require => Class [ "puppet::params","puppet::config" ],
	}

	# Puppet Master Service
	if ( $puppet::master == true ) {
		service { "puppetmaster":
			ensure     => $puppet::params::master_service_ensure,
			name       => $puppet::params::master_service_name,
			hasstatus  => true,
			hasrestart => true,
			require => Class [ "puppet::params","puppet::config" ],
		}
	}

	# Puppet Dashboard Service
	if ( $puppet::dashboard == true ) {
		# TODO finish to implement Puppet Dashboard Service (puppet-dashboard + puppet-dashboard-workers)
		service { $puppet::params::dashboard_service_name:
			ensure     => $puppet::params::dashboard_service_ensure,
			name       => $puppet::params::dashboard_service_name,
			hasstatus  => true,
			hasrestart => true,
			require => Class [ "puppet::params","puppet::config" ],
		}
	}
}
