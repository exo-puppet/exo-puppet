# Ensure to keep up-to-date puppet agent
class puppet {
	
    file { "/etc/apt/sources.list.d/puppet.list":
      ensure => file,
      content => template("${module_name}/sources.list.puppet.erb"),
    }	
		
   exec { "/usr/bin/gpg --keyserver keyserver.ubuntu.com --recv-key 4BD6EC30":
      alias => "getgpgkey",
      require => [ File["/etc/apt/sources.list.d/puppet.list"] ],
      subscribe => [ File["/etc/apt/sources.list.d/puppet.list"] ],
      refreshonly => true      
   }
	
   exec { "/usr/bin/gpg -a --export 4BD6EC30 | /usr/bin/apt-key add -":
      alias => "addgpgkey",
      require => [ Exec["getgpgkey"] ],
      subscribe => [ Exec["getgpgkey"] ],
      refreshonly => true
   }

   exec { "/usr/bin/apt-get update":
      alias => "aptgetupdate",
      require => [ Exec["addgpgkey"] ],
      subscribe => [ Exec["addgpgkey"] ],
      refreshonly => true
   }

   package { "rubygems1.8":
      ensure => latest,
      require => Exec["aptgetupdate"];   	
             "puppet":
      ensure => latest,
      require => Exec["aptgetupdate"];
             "facter":
      ensure => latest,
      require => Exec["aptgetupdate"];
   }
	
   service { "puppet":
      enable => true,
      require => Package[puppet];
   }
}