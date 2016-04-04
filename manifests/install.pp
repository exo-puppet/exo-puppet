# Class: puppet::install
#
# This class manage the installation of the puppet package
class puppet::install {
  case $::operatingsystem {
    /(Ubuntu|Debian)/ : {
      case $::lsbdistrelease {
        /(12.04|14.04|16.04)/ : {
          repo::define { 'puppetlab-repo':
            file_name    => 'puppetlab',
            url          => $puppet::repo_apt_url,
            sections     => [
              'main',
              'dependencies'],
            source       => false,
            key          => '4BD6EC30',
            key_server   => 'keyserver.ubuntu.com',
            notify       => Exec['repo-update'],
          }

          # this file remover is here to clean up puppet.list manually added during system installation
          repo::define { 'puppetlab-oldfile':
            file_name => 'puppet',
            url       => 'http://apt.puppetlabs.com/ubuntu',
            sections  => [
              'main'],
            source    => true,
            installed => false,
            notify    => Exec['repo-update'],
          }
        }
        default   : {
          # this file remover is here to clean up puppetlab.list
          repo::define { 'puppetlab-repo':
            file_name => 'puppetlab',
            url       => $puppet::repo_apt_url,
            sections  => ['main'],
            source    => true,
            installed => false,
            notify    => Exec['repo-update'],
          }
        }
      }
    }
  }

  # Agent packages
  package { [
    'libaugeas-ruby1.8']:
    ensure  => $puppet::params::ensure_mode,
    require => Repo::Define['puppetlab-repo'],
  } -> package { [
    'augeas-tools',
    'augeas-lenses']:
    ensure  => $puppet::params::ensure_mode,
    require => [
      Exec['repo-update'],
      Repo::Define['puppetlab-repo'],
    ],
  } -> package { [
    'puppet',
    'facter']:
    ensure  => $puppet::params::ensure_mode,
    require => [
      Exec['repo-update'],
      Repo::Define['puppetlab-repo'],
    ],
  }

  # Master packages
  if ($puppet::master == true) {
    include puppet::master::install
  }

  # Dashboard packages
  if ($puppet::dashboard == true) {
    include puppet::dashboard::install
  }

  # Foreman packages
  if ($puppet::foreman == true) {
    include puppet::foreman::install
  }
}
