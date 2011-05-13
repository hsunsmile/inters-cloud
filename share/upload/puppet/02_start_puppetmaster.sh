# puppetmasterd --debug --verbose --no-daemonize
auto_domain="*.inters.com"

gembin_path=`gem1.8 env | grep "EXECUTABLE DIRECTORY" | awk '{print $4}'`
no_puppetuser=`id puppet`
[ -z "$no_puppetuser" ] && sudo useradd -d /var/lib/puppet -s /bin/false puppet
[ ! -e /etc/puppet ] && sudo mkdir /etc/puppet
[ ! -e /var/lib/puppet ] && sudo mkdir /var/lib/puppet
[ ! -e /var/puppet ] && sudo mkdir /var/puppet
sudo chown -R puppet.puppet /etc/puppet
sudo chown -R puppet.puppet /var/lib/puppet
sudo chown -R puppet.puppet /var/puppet
have_puppet_ca=`sudo $gembin_path/puppetca list --all | grep puppet`
[ -z "$have_puppet_ca" ] && sudo $gembin_path/puppetca generate puppet
cat <<EOF > autosign.conf 
$auto_domain
EOF
sudo mv autosign.conf /etc/puppet/
sudo cp -pr $HOME/upload/puppet/namespaceauth.conf /etc/puppet/
sudo cp -pr $HOME/upload/puppet/modules /etc/puppet/
sudo cp -pr $HOME/upload/puppet/manifests /etc/puppet/
[ -z "`ps aux | grep [p]uppetmasterd`" ] && sudo $gembin_path/puppetmasterd
