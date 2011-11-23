# Class: puppet::params
#
# This class manage the puppet parameters for different OS
class puppet::params {
	
	$agent_runinterval	= "1800"
	$pluginsync		= "true"
	
	case $::operatingsystem {
		/(Ubuntu|Debian)/: {
			$package_name			= [ "puppet", "facter" ]
			$service_name			= "puppet"
			$config_file			= "/etc/puppet/puppet.conf"
			$config_template		= "puppet.conf.erb"
			
			$logdir					= "/var/log/puppet"
			$vardir					= "/var/lib/puppet"
			$ssldir					= "/var/lib/puppet/ssl"
			$rundir					= "/var/run/puppet"
			$factpath				= "\$vardir/lib/facter"
			$templatedir			= "\$confdir/templates"
			
			$master_modules_path	= "/etc/puppet-exo/modules:\$confdir/modules:/usr/share/puppet/modules"
			$master_manifests_dir	= "/etc/puppet-exo/manifests"
			$master_templates_dir	= "/etc/puppet-exo/templates"
			
			$agent_auto_start		= $puppet::auto_start ? {
				true	=> "yes",
				default	=> "no",
			}
			$agent_service_ensure	= $puppet::auto_start ? {
				true	=> "running",
				default	=> "stopped",
			}
			
		}
		default: {
			fail ("The ${module_name} module is not supported on $::operatingsystem")
		}
	}
}
