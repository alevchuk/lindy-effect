# R

R is a statistical programming and graphing language.

## Hawdware and operating system 

R can run on pretty much any hardware and operating system. Here is what I use:

1. [Get hardware that can run Linux](https://github.com/alevchuk/minibank/blob/master/README.md#model-4--node-at-home)
2. [Install Debian 10 "buster"](https://github.com/alevchuk/minibank/blob/master/README.md#operating-system)


## Building and installing

Install R on Debian 10 "buster" like this.

### Install prerequisites
```
sudo apt install build-essential gfortran libreadline-dev libbz2-dev liblzma-dev libpcre3-dev libcurl4-gnutls-dev
```

### Create a new account
```
sudo adduser --disabled-password r
```
All files will live under `/home/r`

### Download source code and Build
```
sudo su -l r

mkdir ~/src
curl https://cran.r-project.org/src/base/R-3/R-3.6.1.tar.gz > ~/src/R-3.6.1.tar.gz

cd ~/src/R-3.6.1/
./configure --with-x=no --enable-java=no --prefix=$HOME/bin
make
make install
```

### Add to path

Add binary path export to the end of `~/.profile` like this:

```
echo 'export PATH=$HOME/bin/bin:$PATH' >> ~/.profile
source ~/.profile
```

## To use R

To use R, change into the R user account:
```
sudo su -l r
```
