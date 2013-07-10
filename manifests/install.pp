# Class: puppet::install
#
# This class manage the installation of the puppet package
class puppet::install {
  case $::operatingsystem {
    /(Ubuntu|Debian)/ : {
      repo::define { 'puppetlab-repo':
        file_name  => 'puppetlab',
        url        => $puppet::repo_apt_url,
        sections   => [
          'main',
          'dependencies'],
        source     => false,
        key        => '4BD6EC30',
        key_server => 'keyserver.ubuntu.com',
        notify     => Exec['repo-update'],
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

      # We need to upgrade augeas and libaugeas_ruby from non official packages
      # to avoid some bugs/incompatibilities like to edit limits files under
      # /etc/security/limits.d/
      case $::lsbdistrelease {
        /(10.04)/ : {
          repo::define { 'skettler-ppa-repo':
            file_name  => 'skettler-ppa',
            url        => 'http://ppa.launchpad.net/skettler/puppet/ubuntu',
            sections   => [
              'main'],
            source     => true,
            key        => 'C18789EA',
            key_server => 'keyserver.ubuntu.com',
            notify     => Exec['repo-update'],
          }
        }
        /(10.10)/ : {
          repo::define { 'raphink-ppa-repo':
            file_name  => 'raphink-ppa',
            url        => 'http://ppa.launchpad.net/raphink/augeas/ubuntu',
            sections   => [
              'main'],
            source     => true,
            key        => 'AE498453',
            key_server => 'keyserver.ubuntu.com',
            notify     => Exec['repo-update'],
          }
        }
        default   : {
        }
      }
    }
  }

  # Agent packages
  package { [
    'libaugeas-ruby1.8']:
    ensure  => 'latest',
    require => [
      Exec['repo-update'],
      $::lsbdistrelease ? {
        /(10.04)/ => Repo::Define['puppetlab-repo', 'skettler-ppa-repo'],
        /(10.10)/ => Repo::Define['puppetlab-repo', 'raphink-ppa-repo'],
        default   => Repo::Define['puppetlab-repo']
      } ],
  } -> package { [
    'augeas-tools',
    'augeas-lenses']:
    ensure  => 'latest',
    require => [
      Exec['repo-update'],
      $::lsbdistrelease ? {
        /(10.04)/ => Repo::Define['puppetlab-repo', 'skettler-ppa-repo'],
        /(10.10)/ => Repo::Define['puppetlab-repo', 'raphink-ppa-repo'],
        default   => Repo::Define['puppetlab-repo']
      } ],
  } -> package { [
    'puppet',
    'facter']:
    ensure  => $puppet::params::ensure_mode,
    require => [
      Exec['repo-update'],
      $::lsbdistrelease ? {
        /(10.04)/ => Repo::Define['puppetlab-repo', 'skettler-ppa-repo'],
        /(10.10)/ => Repo::Define['puppetlab-repo', 'raphink-ppa-repo'],
        default   => Repo::Define['puppetlab-repo']
      } ],
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
