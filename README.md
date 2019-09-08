# lindy-effect
Statistical testing of the [Lindy effect](https://en.wikipedia.org/wiki/Lindy_effect)


## About the experiment

We test the accuracy of the Lindy Effect on the history of Linux distributions.

The source code of the experiment is here:
[process.R](@alevchuk/lindy-effect/blob/master/process.R)


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
mkdir ~/lindy-data
curl https://raw.githubusercontent.com/FabioLolix/LinuxTimeline/28e13cc8f406546a701b6e5c197ee20da58b5d66/gldt.csv > gldt.csv
```

### Download and run the experiment

Change into the R user account:
```
sudo su -l r
```

Download script:
```
cd ~/lindy-data
curl https://raw.githubusercontent.com/alevchuk/lindy-effect/master/process.R > process.R
chmod +x process.R
```

Run experiment:
```
./process.R
```
