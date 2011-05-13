import "modules.pp"

Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }
$MONGO_HOST='46.51.252.65'

node default {
  include 'tinc'
  include 'mongodb'

  tinc::vpn_net { inters:
    tinc_interface => 'eth0',
    tinc_internal_interface => 'eth0',
    key_source_path => '/etc/tinc'
  }
}

node inters-ec2-host1 inherits default {
}
