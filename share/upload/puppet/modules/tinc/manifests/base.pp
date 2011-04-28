class tinc::base {

   package{'tinc':
       ensure => installed,
   }

   service{tinc:
        ensure => running,
        enable => true,
        hasstatus => true, 
        require => Package[tinc],
   }

  file{"/etc/tinc/nets.boot":
    ensure => present,
    require => Package['tinc'],
    before => Service['tinc'],
    owner => root, group => root, mode => 0660;
  }

}


