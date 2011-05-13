# Class: mongodb
#
# This class installs MongoDB (stable)
#
# Notes:
#  This class is Ubuntu specific.
#  By Sean Porter, Gastown Labs Inc.
#
# Actions:
#  - Install MongoDB using a 10gen Ubuntu repository
#  - Manage the MongoDB service
#  - MongoDB can be part of a replica set
#
# Sample Usage:
#  include mongodb
#
class mongodb {
	include mongodb::params
	
	package { "python-software-properties":
		ensure => installed,
	}
	
	exec { "10gen-apt-repo":
		path => "/bin:/usr/bin",
		command => "add-apt-repository '${mongodb::params::repository}'",
		unless => "cat /etc/apt/sources.list | grep 10gen",
		require => Package["python-software-properties"],
	}
	
	exec { "10gen-apt-key":
		path => "/bin:/usr/bin",
		command => "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
		unless => "apt-key list | grep 10gen",
		require => Exec["10gen-apt-repo"],
	}

	file { "/tmp/mongodb-10gen_1.8.1_amd64.deb":
		source => "puppet:///modules/mongodb/mongodb-10gen_1.8.1_amd64.deb",
	}

	exec { "install-mongodb-manually":
		command => "sudo dpkg -i /tmp/mongodb-10gen_1.8.1_amd64.deb",
		unless => "dpkg -s mongodb 2>/dev/null",
		require => File["/tmp/mongodb-10gen_1.8.1_amd64.deb"],
	}

	exec { "update-apt":
		path => "/bin:/usr/bin",
		command => "apt-get update",
		require => Exec["10gen-apt-key"],
	}

	package { "mongodb-10gen":
		ensure => installed,
		require => Exec["update-apt"],
	}
	
	service { "mongodb":
		enable => true,
		ensure => running,
		require => Exec["install-mongodb-manually"],
	}

	define replica_set {
		file { "/etc/init/mongodb.conf":
			content => template("mongodb/mongodb.conf.erb"),
			mode => "0644",
			notify => Service["mongodb"],
			require => Package["mongodb-10gen"],
		}
	}

	define mongofile_put {
		exec { "mongofile_put_${name}":
			command => "mongofiles -r --host ${MONGO_HOST} put ${name}",
			require => Service["mongodb"],
		}
	}

	define mongofile_get {
		exec { "mongofile_get_${name}":
			command => "mongo_get ${MONGO_HOST} ${name} && echo ''",
			require => Service["mongodb"],
		}
	}

}
