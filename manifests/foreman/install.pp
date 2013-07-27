# Class: puppet::foreman::install
#
# This class manage the installation of the foreman package
class puppet::foreman::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      case $::lsbdistrelease {
        /(12.04)/ : {
          # Install the foreman apt-key for the deb repo (if not already present)
          # FIXME : we should check the key fingerprint for better security ("1DCB 15D1 2CA1 40EE F494  7E57 66CF 053F E775 FF07")
          exec { 'forman-repo-key':
            command => 'wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -',
            path    => [
              '/bin',
              '/usr/bin',
              '/usr/sbin'],
            unless  => '/usr/bin/apt-key list | grep E775FF07',
          } -> repo::define { 'foreman-repo':
            file_name => 'foreman',
            url       => 'http://deb.theforeman.org/',
            sections  => [
              'stable'],
            source    => false,
            notify    => Exec['repo-update'],
          }
        }
        default   : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease} (only 12.04 Precise is supported)"
          )
        }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }

  package { 'foreman':
    ensure  => $puppet::params::ensure_mode,
    require => [
      Exec['repo-update'],
      Repo::Define['foreman-repo']],
  } -> package { 'foreman-mysql': ensure => $puppet::params::ensure_mode, } -> package { 'foreman-sqlite3': ensure =>
    $puppet::params::ensure_mode, }
}
