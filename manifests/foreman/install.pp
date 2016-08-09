# Class: puppet::foreman::install
#
# This class manage the installation of the foreman package
class puppet::foreman::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      case $::lsbdistrelease {
        /(12.04)/ : {
          $forman_version = '1.7'

          apt::key { 'foreman':
            id      => 'AE0AF310E2EA96B6B6F4BD726F8600B9563278F6',
            server  => 'keyserver.ubuntu.com',
          }
          apt::source { 'foreman':
            location => 'http://deb.theforeman.org/',
            repos    => $forman_version,
          }
          apt::source { 'foreman-plugins':
            location       => 'http://deb.theforeman.org/',
            repos          => $forman_version,
            release        => 'plugins',
          }

          ensure_packages ( ['foreman','foreman-mysql2'], {
            'ensure' => $puppet::params::ensure_mode,
            'require' => [Apt::Source['foreman'],Apt::Ppa['ppa:brightbox/ruby-ng'],Package['ruby1.9.3']],
          } )
        }
        default   : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease} (only 12.04 Precise is supported)" )
        }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
