# Class: puppet::service
#
# This class manage the puppet service
class puppet::service {
	include "puppet::params"
	
	service { "puppet":
		ensure     => $puppet::params::agent_service_ensure,
		name       => $puppet::params::service_name,
		hasstatus  => true,
		hasrestart => false,
		require => Class [ "puppet::params","puppet::config" ],
	}
}
