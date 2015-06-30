#--------> Build box script
#-------> origin: https://nicolas.steinmetz.fr/blog/post/PHP-5.6.3-%28dotdeb%29-pour-cubietruck-%28armhf%29

#----> Add DotDeb to repo sources and DotDeb key
echo "deb-src http://packages.dotdeb.org wheezy all\ndeb-src http://packages.dotdeb.org wheezy-php56 all" > /etc/apt/sources.list.d/dotdeb.list
wget http://www.dotdeb.org/dotdeb.gpg -O - | apt-key add -

#----> Update, upgrade repo and prepare build environment
apt-get update && apt-get upgrade -y

#----> Install dependencies for build
apt-get install build-essential fakeroot -y

#----> Get PHP5 dependencies
apt-get build-dep php5 

#----> Start compile of PHP5 
cd /tmp && apt-get source php5 --compile

#----> Create own repository
mkdir /var/local/repository
echo "deb [ trusted=yes ] file:///var/local/repository ./" > /etc/apt/sources.list.d/dotDeb-dotPi.list
mv /tmp/*.deb /var/local/repository/
cd /var/local/repository
dpkg-scanpackages ./ > Packages && gzip -f Packages

#----> Update your package list
apt-get update

#----> PECL extensions
aptitute install php-pear -y

#--> Get required lib to build pecl extension as deb packages :
wget http://packages.dotdeb.org/dists/wheezy-php56/debpear/binary-all/debpear_0.4-1~dotdeb.1_all.deb
wget http://packages.dotdeb.org/dists/wheezy-php56/pear-channels/binary-all/pear-channels_0~20140806-1_all.deb
wget http://packages.dotdeb.org/dists/wheezy-php56/dh-php5/binary-all/dh-php5_0.2_all.deb
wget http://packages.dotdeb.org/dists/wheezy-php56/pkg-php-tools/binary-all/pkg-php-tools_1.21_all.deb

#-->  Add these packages to your local repository
mv *.deb /var/local/repository
cd /var/local/repository
dpkg-scanpackages ./ > Packages && gzip -f Packages
aptitude update
aptitude install debpear dh-php5 pkg-php-tools pear-channels -y


#----> For ImageMagick
#--> Get dependencies
apt-get install libmagickwand-dev libmagickcore-dev imagemagick

#--> Grab and build  pecl imagick extension package
debpear -c pecl imagick
