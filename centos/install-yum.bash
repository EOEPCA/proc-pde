
yum install -y $( cat /tmp/yum.list | tr '\n' ' ' )

res=$?
rm -f /tmp/yum.list

yum group install -y "Development Tools"

# install git >= 2.11
wget https://github.com/git/git/archive/v2.28.0.tar.gz -O git.tar.gz

tar -zxf git.tar.gz

cd git-*

make configure

./configure --prefix=/usr/local --with-curl

make install

cd ..

rm -fr git-*

yum clean all -y

exit ${res}
