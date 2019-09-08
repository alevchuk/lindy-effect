# lindy-effect
Statistical testing of the [Lindy effect](https://en.wikipedia.org/wiki/Lindy_effect)

## Steps to reproduce

### Prerequisites
1. [Get hardware that can run Linux](https://github.com/alevchuk/minibank/blob/master/README.md#model-4--node-at-home)
2. [Install Debian 10 "buster"](https://github.com/alevchuk/minibank/blob/master/README.md#operating-system)
3. [Install R](https://github.com/alevchuk/lindy-effect/blob/master/R/README.md)

### Download source data

I'm using the [2019 May 4 version of FabioLolix/LinuxTimeline data](https://github.com/FabioLolix/LinuxTimeline/commit/28e13cc8f406546a701b6e5c197ee20da58b5d66)

Change into the R user account:
```
sudo su -l r
```

Download:
```
mkdir ~/data
curl https://raw.githubusercontent.com/FabioLolix/LinuxTimeline/28e13cc8f406546a701b6e5c197ee20da58b5d66/gldt.csv > gldt.csv
```

