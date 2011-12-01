# Class: puppet
#
#   This module manages the puppet agent service.
#
#   Tested platforms:
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.04 Lucid
#
# Parameters:
#	$agent_auto_start:
#		allow puppet agent service to start at boot time or not (true / false) (default: true)
#	$lastversion:
#		this variable allow to chose if the package should always be updated to the last available version (true) or not (false) (default: false)
#
# Actions:
#  Installs, configures, and manages the puppet service.
#
# Requires:
#
# **Simple Agent Usage:**
#
#   class { "puppet":
#		agent_auto_start	=> true,
#		lastversion			=> false,
#		master				=> false,
#		master_fqdn			=> puppet.$::domain,
#   }
#
# **Simple Agent and Master Usage:**
#
#   class { "puppet":
#		agent_auto_start	=> true,
#		lastversion			=> false,
#		master				=> true,
#		master_fqdn			=> $::fqdn,
#   }
#
# [Remember: No empty lines between comments and class definition]
class puppet (	$lastversion = false, 
										$agent_auto_start 		= true, 																			$agent_pp_dir 	= "/etc/puppet",	$agent_runinterval = "1800",
				$master 	= false, 	$master_auto_start 		= true, 	$master_fqdn 	= "puppet.$::domain", 		$master_port 	= "8140", 	$master_pp_dir	= "/etc/puppet",	$master_dns_alt_name = "",
				$dashboard 	= false, 	$dashboard_auto_start 	= true, 	$dashboard_fqdn = "dashboard.$::domain", 	$dashboard_port	= "3000" 
			 ) {
	
	# TODO Implement Apache Passenger support for Puppet Master (need vhost and conf.d feature of new apache2 module - SWF-1621)  
	
	# parameters validation
	if ($lastversion != true) and ($lastversion != false) {
		fail("lastversion parameter must be true or false")
	}
	if ($master != true) and ($master != false) {
		fail("master parameter must be true or false")
	}
	if ($dashboard != true) and ($dashboard != false) {
		fail("dashboard parameter must be true or false")
	}

	include puppet::params, puppet::install, puppet::config, puppet::service

}