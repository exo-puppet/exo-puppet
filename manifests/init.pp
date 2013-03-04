################################################################################
#
#   This module manages the puppet agent services (agent, master, dashboard).
#
#   Tested platforms:
#    - Ubuntu 11.10 Oneiric
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.04 Lucid
#
# == Parameters
#
# [+lastversion+]
#   (OPTIONAL) (default: false)
#
#   this variable allow to chose if the package should always be updated to the last available version (true) or not (false) (default: false)
#
# [+agent_auto_start+]
#   (OPTIONAL) (default: true)
#
#   allow puppet agent service to start at boot time (true) or not (false)
#
# [+repo_apt_url+]
#   (OPTIONAL) (default: http://apt.puppetlabs.com/ubuntu)
#
#   the url of the deb repository for PuppetLabs.
#
# [+agent_pp_dir+]
#   (OPTIONAL) (default: /etc/puppet)
#
#   The agent puppet parent directory specify where is stored the puppet configuration for agent
#
# [+agent_runinterval+]
#   (OPTIONAL) (default: 1800 => every 30 minutes)
#
#   The frequency for the puppet agent to execute in seconds
#
# [+master+]
#   (OPTIONAL) (default: false)
#
#   allow puppet master on this node (true) or not (false)
#
# [+master_auto_start+]
#   (OPTIONAL) (default: true)
#
#   allow puppet master service to start at boot time (true) or not (false)
#
# [+master_fqdn+]
#   (OPTIONAL) (default: puppet.${::domain})
#
#   the fully qualified domain name of the puppet master
#
# [+master_port+]
#   (OPTIONAL) (default: 8140)
#
#   the port used by puppet master to listen for agent connexions
#
# [+master_pp_dir+]
#   (OPTIONAL) (default: /etc/puppet)
#
#   The master puppet parent directory specify where is stored the puppet configuration for master
#master_other_modules_dirs
# [+master_other_modules_dirs+]
#   (OPTIONAL) (default: "")
#
#   this parameter allow us to add complementary directories for Puppet Master to search modules.
#   IMPORTANT : each directory must be separated by a semicolon (ex: /my/directory/number1:/my/directory/number2)
#
# [+master_dns_alt_name+]
#   (OPTIONAL) (default: )
#
#   a comma separated list of fully qualified name DNS aliases for the master nodes (it only make sens on the node with puppet master)
#
# [+dashboard+]
#   (OPTIONAL) (default: false)
#
#   allow puppet dashboard on this node (true) or not (false)
#
# [+dashboard_auto_start+]
#   (OPTIONAL) (default: true)
#
#   allow puppet dashboard service to start at boot time (true) or not (false)
#
# [+dashboard_fqdn+]
#   (OPTIONAL) (default: dashboard.${::domain})
#
#   the fully qualified domain name of the puppet dashboard
#
# [+dashboard_port+]
#   (OPTIONAL) (default: 3000)
#
#   the port used by puppet dashboard to listen for puppet master connexions
#
# [+dashboard_db_name+]
#   (OPTIONAL) (default: dashboard)
#
#   the database name used by puppet dashboard
#
# [+dashboard_db_user+]
#   (OPTIONAL) (default: dashboard)
#
#   the database username used by puppet dashboard to connect to the dashboard database
#
# [+dashboard_db_pwd+]
#   (OPTIONAL) (default: dashboard)
#
#   the database password used by puppet dashboard to connect to the dashboard database
#
# [+dashboard_workers_nb+]
#   (OPTIONAL) (default: 2)
#
#   Number of dashboard workers to start. This will be the number of jobs that can be concurrently processed.
#   A simple recommendation would be to start with the number of cores you have available.
#
# == Modules Dependencies
#
# [+repo+]
#   the +repo+ puppet module is needed to :
#
#   - install the puppetlab package repository and pupetlab repo GPG key (in puppet::install)
#
#   - refresh the repository before installing package (in puppet::install)
#
# == Examples
#
# === Simple Agent Usage
#
#   class { "puppet":
#       agent_auto_start    => true,
#       lastversion         => true,
#       master              => false,
#       master_fqdn         => puppet.${::domain},
#   }
#
# === Simple Agent and Master Usage
#
#   class { "puppet":
#       agent_auto_start    => true,
#       lastversion         => true,
#       master              => true,
#       master_auto_start   => true,
#       master_fqdn         => puppet.${::domain},
#   }
#
################################################################################
class puppet (	$lastversion = false,      $repo_apt_url ="http://apt.puppetlabs.com/ubuntu",
                $agent_auto_start = true,  $agent_pp_dir 	= "/etc/puppet",	$agent_runinterval = "1800",
				        $master 	= false, 	       $master_auto_start 		= true, 	$master_fqdn 	= "puppet.${::domain}", 	   $master_port 	= "8140", 	$master_pp_dir = "/etc/puppet",   $master_other_modules_dirs = "",   $master_dns_alt_name = "",
				        $dashboard 	= false, 	     $dashboard_auto_start 	= true, 	$dashboard_fqdn = "dashboard.${::domain}", $dashboard_port	= "3000", $dashboard_db_name = "dashboard", $dashboard_db_user = "dashboard",  $dashboard_db_pwd = "dashboard", $dashboard_workers_nb = "2",
			 ) {

	include repo

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
