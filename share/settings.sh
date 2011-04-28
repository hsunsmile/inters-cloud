
ec2_reigion="us-west-1"
ec2_instance_arch="64-bit"
ec2_instance_store="ebs"
ec2_match_str="$ec2_reigion.*$ec2_instance_arch.*$ec2_instance_store "
ubuntu_amilists="http://uec-images.ubuntu.com/releases/10.04/release/"
ami_id=`curl -s $ubuntu_amilists | sed '/<tr>/{N;N;N;N;s/\n//g;}' | grep "$ec2_match_str" | grep -o "ami-[0-9a-z]\{8\}"`

inters_home="$HOME/.mybin"
inters_env="$inters_home/share/upload/inters.sh"

keypair="inters"
group="default"
inst_type="t1.micro"
hosttag_base="inters-ec2-host"
hostdomain="inters.com"
vpn_netaddr="10.0.0."
ssh_config="$HOME/.ssh/config_inters"

