#--------> Build box script
#-------> origin: https://nicolas.steinmetz.fr/blog/post/PHP-5.5.17-(dotdeb)-pour-cubietruck-(armhf)

#----> Add DotDeb to repo sources and DotDeb key
echo "deb-src http://packages.dotdeb.org wheezy all\ndeb-src http://packages.dotdeb.org wheezy-php55 all" > /etc/apt/sources.list.d/dotdeb.list

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

#----> Install compiled PHP
apt-get install php5 php5-fpm php5-cli 

#----> PECL extensions
aptitute install php-pear -y

#----> For ImageMagick
#--> Get dependencies
apt-get install libmagickwand-dev libmagickcore-dev imagemagick

#--> Get debianize script
wget https://raw.githubusercontent.com/gplessis/dotdeb-php5-pecl/wheezy-php55/debianize && chmod +x debianize

#--> Define some variables
export DEBFULLNAME="Your Self"
export DEBEMAIL="Mail@Some.Where"

#--> Grab pecl archive
pecl download imagick
tar xzf imagick-3.1.2.tgz

#--> Build package (as root)
./debianize imagick-3.1.2
