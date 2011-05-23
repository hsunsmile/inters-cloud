import "modules.pp"

Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }
$MONGO_HOST='46.51.253.99'

node default {}

node inters {
	include 'tinc'
	include 'mongodb'
	include 'torque'

	package { mailutils: ensure => installed }

	tinc::vpn_net { inters:
		tinc_interface => 'eth0',
		tinc_internal_interface => 'eth0',
		key_source_path => '/etc/tinc'
	}
}

node /^inters-ec2-host\d+/ inherits inters { }
node /.+\.sxu\.com$/ {
		package { mailutils: ensure => installed }
		package { python: ensure => installed }
		package { libmysqlclient16-dev: ensure => installed }
		package { python-dev: ensure => installed }
		package { python-pip: ensure => installed }
		package { python-pycurl: ensure => installed }
		package { nginx: ensure => installed }
		package { mysql-common: ensure => installed }
		package { mysql-client: ensure => installed }
		package { mysql-server: ensure => installed }
		exec { 'install venv':
						command => "sudo easy_install virtualenv",
						require => Package["python-pip"] }
		exec { 'install gunicron':
						command => "sudo easy_install gunicorn",
						require => Package["python-pip"] }
		exec { 'install tornado':
						cwd => "/root",
						command => "sudo easy_install tornado",
						require => Package["python-pip", "python-pycurl"] }
		exec { 'install supervisor':
						command => "sudo easy_install supervisor",
						require => Package["python-pip"] }
		exec { 'install mysqldb':
						command => "sudo easy_install MySQL-python",
						require => Package["python-pip"] }
}
