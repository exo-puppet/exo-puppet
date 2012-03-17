# Class: puppet::params
#
# This class manage the puppet parameters for different OS
class puppet::params {
	
	$ensure_mode = $puppet::lastversion ? {
		true => latest,
		default => present
	}
	#notify { "puppet ensure mode = $ensure_mode": withpath => false }
	info ("puppet ensure mode = $ensure_mode")
	
	$pluginsync		= true
	
	case $::operatingsystem {
		/(Ubuntu|Debian)/: {
			#$package_name		 	= [ "puppet", "facter" ]
			$service_name			= "puppet"
			$config_file			= "/etc/puppet/puppet.conf"
			$config_template		= "puppet.conf.erb"
			
			$logdir					= "/var/log/puppet"
			$libdir                 = "/var/lib"
			$vardir					= "${libdir}/puppet"
			$ssldir					= "${libdir}/puppet/ssl"
			$reportsdir             = "${libdir}/puppet/reports"
			
			$rundir					= "/var/run/puppet"
			$factpath				= "\$vardir/lib/facter"
			
			# Agent specific configuration
			$agent_template_dir		= "${puppet::agent_pp_dir}/templates"
			
			$agent_auto_start		= $puppet::agent_auto_start ? {
				true	=> "yes",
				default	=> "no",
			}
			$agent_service_ensure	= $puppet::agent_auto_start ? {
				true	=> "running",
				default	=> "stopped",
			}
			
			# Master specific configuration
			$master_service_name	= "puppetmaster"

            if ( $puppet::master_other_modules_dirs == "") {
                $master_modules_path    = "${puppet::master_pp_dir}/modules:/usr/share/puppet/modules"
            } else {
                $master_modules_path    = "${puppet::master_pp_dir}/modules:${puppet::master_other_modules_dirs}:/usr/share/puppet/modules"
            }
			$master_manifests_dir	= "${puppet::master_pp_dir}/manifests"
			$master_templates_dir	= "${puppet::master_pp_dir}/templates"
			
			$master_auto_start		= $puppet::master_auto_start ? {
				true	=> "yes",
				default	=> "no",
			}
			$master_service_ensure	= $puppet::master_auto_start ? {
				true	=> "running",
				default	=> "stopped",
			}
			
			# Dashboard specific configuration
			$dashboard_service_name	= ["puppet-dashboard", "puppet-dashboard-workers"]

			$dashboard_auto_start		= $puppet::dashboard_auto_start ? {
				true	=> "yes",
				default	=> "no",
			}
			$dashboard_service_ensure	= $puppet::dashboard_auto_start ? {
				true	=> "running",
				default	=> "stopped",
			}
			
			
		}
		default: {
			fail ("The ${module_name} module is not supported on $::operatingsystem")
		}
	}
}
