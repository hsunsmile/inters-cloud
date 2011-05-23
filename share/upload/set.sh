domain_name="inters.com"
tag_base="inters-ec2-host"

instance_tag="$tag_base""$1"
node_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo "$instance_tag" | tee /etc/hostname
hostname $instance_tag
node_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
sed -i "/^$node_ip/d" /etc/hosts
echo "$node_ip	$instance_tag.$domain_name	$instance_tag" | tee -a /etc/hosts

[ ! -e $HOME/.ssh ] && mkdir $HOME/.ssh
mv $HOME/upload/id_rsa $HOME/.ssh/
cat $HOME/upload/authorized_keys >> $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/*
sudo mv $HOME/upload/inters.sh /etc/profile.d/
sudo mv $HOME/upload/mongo_get /usr/bin/
sudo sed -i -e "/\/arch/ s/arch/jp.arch/" /etc/apt/sources.list
inters_cron="$HOME/upload/inters_crontab"
crontab < $inters_cron
