# Class: puppet::service
#
# This class manage the puppet service
class puppet::service {
	service { "puppet":
		ensure     => running,
		name       => $puppet::params::service_name,
		hasstatus  => true,
		hasrestart => true,
		require => Class [ "puppet::config" ],
	}
}
