#!/bin/bash

yum install -y redhat-lsb-core
yum install -y yum-utils
yum-config-manager --enable rhui-REGION-rhel-server-optional
yum install -y augeas-devel ncurses-devel gcc gcc-c++ curl git
yum install -y ruby ruby-revel
gem install puppet:3.8.7 hiera facter ruby-augeas hiera-eyaml ruby-shadow


mkdir -p /etc/facter/facts.d
export FACTER_init_role=$1
echo “init_role=$1” > /etc/facter/facts.d/init_role.txt

echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAp9pQVZHcriN5Lips0R4VsAs/50wNJiAMShGvdU3PLmutAk1Hpig+q5vlBVXe
snX93dWeeQLh5rjbWFZD5GzYySN2mY+CExf43GgpC4Kfij1OvV7F3pOmL/dBGgENdk22YAco4IRY
yS7DgNbn5GJsqHYmkepnC+b+P4yhFoVucKgZ+5p0+yuy1LlmeH7oRQsYmoFJqCEeTtq9t28ifJVL
FUJ377pWuhS67M4R7VASPGqFdesgtx26qoowAcGoE9s2RPty7o70AhSXFyTLZ+jdnADNUTR8/Fo/
oetJh+J1NLd0gmAubXZB5sJEoND1JdrKP4PJmVjetflaBG7nODkdewIDAQABAoIBAQCQ5EcMVojk
WQK18zFTomCeQle7VU7UZj21gmavH6eELrZ9kjATIhJXGI8td95wtqGZ6FiPpQlTnKbbLjwU5lCL
7+zkyZhC2yKbP96ObQdC0YEyvqiXZWTDau/rfpUcViDj68pBZH0vzQo+IUSzRLL/CF5q/qhNAeze
9onnYu7elxDbPn808qzBDKJx4GDNbuv8JDLfc0gFdU8dMmX0QBPZfuDD4I/HwQ7nBskvQ86177/M
8jDY7T7vmQwKepXe7D4qtygbPzud+oZ6uNXS4NWNRzB/659YZnhtLGBcjy0RAc8/qkuw/mnxMpyb
yRkY3cpjGeGWB3QUu5lz7CCKSvOhAoGBAPqqvGBvV8UabWBHKTIsJz2I0tU0YrKfkd6Y8B0a0ZLW
lkK2tcSf8tNWktuy/q1SuJb17ielKjhanK3OmOYqRHpX+fRLPTI/Jp6LiDirb65y6r7jfOnPuv5Y
u3XTUsiNWrsBOXKUP6cza7UxXNNji8EnYMIEoCqu3E92yJFLP5DPAoGBAKtsh0s2lSEQG1Ew8SGJ
GSyiuPnWtZuhZTJfIJxnOMb9aCga8kW3FLcYJsHGoY3G0lxHQEzFuBpNEWLVUAjhBH4ZHI+NJhpS
xGQmLXxmrniapbuRKG/XZSptGGEkFR/dXK/wyku3kosQLL082qaleqlyCtylbIHemvDQ7GI9zBuV
AoGAQMjjyuC8BHsiDaIWqZrzwVmdc/EIGTZYkvlgBYWq6JKBX1itfdYBAlH7vsByRgV9I7cICEMN
uGbi26Drr4D5Fc2rElJnzJa5unxBhrP4N1QIC7Hr1NoVcCsqt/cYDDFMY8ybNlvOX75QdhH99bxi
oFc3EK31X1K2Ket/Rt313c0CgYBNb0TeMNXEjaYJUvZZk7iPdSHhmZ+Hoaw4yMfOXsJDAQ0fsKxn
2X++BWbceYFYrcswa+8bvuSe3NlRr9HrcNm6rFU+cyAXG/Qi2SwK2cdOK21aAQQnIUFNnOI6XzY7
op7PyxFWiqHjt3a+NNMAHBgAmsdVTFRrhcavqXBeIFQm0QKBgHb6ki/pGqqiqHtiC8UhbHsYpyG/
7AfXjUaXxC6qBgrLqGqVxlnGh+8waXGdoPM4efGxUMuVfT8M3yHyTM0w+hbixvChqPmlZ+k3RwLp
wQmqrRcIGMmuaK/NDe2rtU1Fhpktkj4Voso8ydiJXVhq3YpsPSCyMTl6qh9Gndf7Am9y
-----END RSA PRIVATE KEY-----" > /root/.ssh/id_rsa
echo "StrictHostKeyChecking=no" > /root/.ssh/config
chmod -R 600 /root/.ssh

cd /opt && git clone git@github.com:rajeshgopal/test-provisioning.git

rm -rf /etc/puppet /etc/hiera.yaml
ln -s /opt/test-provisioning /etc/puppet
ln -s /etc/puppet/hiera.yaml /etc/hiera.yaml

gem install activesupport librarian-puppet
#librarian-puppet install --verbose

puppet apply /etc/puppet/manifest/site.pp
