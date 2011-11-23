# Class: puppet
#
#   This module manages the puppet agent service.
#
#   Tested platforms:
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.04 Lucid
#
# Parameters:
#
# Actions:
#  Installs, configures, and manages the puppet service.
#
# Requires:
#
# Sample Usage:
#
#   class { "puppet":
#   }
#
# [Remember: No empty lines between comments and class definition]
class puppet {
	
	include puppet::params, puppet::install, puppet::config, puppet::service

}