# puppetmasterd --debug --verbose --no-daemonize
auto_domain=`hostname -d`
[ -z "$auto_domain" ] && auto_domain='inters.com'
base_dir=`dirname $0`

gembin_path=`gem1.8 env | grep "EXECUTABLE DIRECTORY" | awk '{print $4}'`
[ ! -e /etc/profile.d/gem.sh ] && echo "PATH=\$PATH:$gembin_path" | tee -a /etc/profile.d/gem.sh

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
*.$auto_domain
EOF
sudo mv autosign.conf /etc/puppet/
sudo cp -pr $base_dir/namespaceauth.conf /etc/puppet/
sudo cp -pr $base_dir/modules /etc/puppet/
sudo cp -pr $base_dir/manifests /etc/puppet/
pgrep puppetmasterd | xargs sudo kill -9 2>&1 >/dev/null || echo "kill old puppetmaster"
# [ -z "`ps aux | grep [p]uppetmasterd`" ] && sudo $gembin_path/puppetmasterd
sudo $gembin_path/puppetmasterd
