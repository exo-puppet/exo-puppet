# Ensure to keep up-to-date puppet agent
class puppet {
	
    file { "/etc/apt/sources.list.d/puppet.list":
      ensure => file,
      content => template("${module_name}/sources.list.puppet.erb"),
    }	
		
   exec { "/usr/bin/gpg --keyserver keyserver.ubuntu.com --recv-key 4BD6EC30":
      alias => "puppet-getgpgkey",
      require => [ File["/etc/apt/sources.list.d/puppet.list"] ],
      subscribe => [ File["/etc/apt/sources.list.d/puppet.list"] ],
      refreshonly => true      
   }
	
   exec { "/usr/bin/gpg -a --export 4BD6EC30 | /usr/bin/apt-key add -":
      alias => "puppet-addgpgkey",
      require => [ Exec["puppet-getgpgkey"] ],
      subscribe => [ Exec["puppet-getgpgkey"] ],
      refreshonly => true
   }

   exec { "puppet-aptgetupdate":
      command => "/usr/bin/apt-get update",
      alias => "puppet-aptgetupdate",
      require => [ Exec["puppet-addgpgkey"] ],
      subscribe => [ Exec["puppet-addgpgkey"] ],
      refreshonly => true
   }

   package { "rubygems1.8":
      ensure => latest,
      require => Exec["puppet-aptgetupdate"];   	
             "puppet":
      ensure => latest,
      require => Exec["puppet-aptgetupdate"];
             "facter":
      ensure => latest,
      require => Exec["puppet-aptgetupdate"];
   }
	
   service { "puppet":
      enable => true,
      require => Package[puppet];
   }
}