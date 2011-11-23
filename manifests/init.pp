# Class: puppet
#
#   This module manages the puppet agent service.
#
#   Tested platforms:
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.04 Lucid
#
# Parameters:
#	$auto_start:
#		allow puppet agent service to start at boot time or not (true / false) (default: true)
#	$lastversion:
#		this variable allow to chose if the package should always be updated to the last available version (true) or not (false) (default: false)
#
# Actions:
#  Installs, configures, and manages the puppet service.
#
# Requires:
#
# Sample Usage:
#
#   class { "puppet":
#		auto_start	=> true,
#		lastversion	=> false,
#   }
#
# [Remember: No empty lines between comments and class definition]
class puppet ($auto_start=true, $lastversion = "false") {
	
	# parameters validation
	if ($lastversion != true) and ($lastversion != false) {
		fail("lastversion must be true or false")
	}

	include puppet::params, puppet::install, puppet::config, puppet::service

}