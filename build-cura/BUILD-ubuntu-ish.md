building from source
====================

found here: https://forum.lulzbot.com/viewtopic.php?t=9644#p47293

```
sudo apt-get install python libsm-dev libxi-dev libfontconfig1-dev libbsd-dev libxdmcp-dev libxcb1-dev libgl1-mesa-dev libgcrypt20-dev liblz4-dev liblzma-dev libselinux1-dev libsystemd-dev libdbus-1-dev libstdc++-6-dev libglib2.0-dev libc6-dev libssl1.0-dev libtinfo-dev libreadline-dev libharfbuzz-dev libxkbcommon-dev gfortran gcc uuid-dev git wget curl cmake build-essential

mkdir -p ~/projects/cura-lulzbot
cd  ~/projects/cura-lulzbot
mkdir Projects && mkdir Projects/cura
cd Projects/cura/
git clone https://code.alephobjects.com/source/curabuild-lulzbot.git build-master

mkdir build-master/build && cd build-master
./build_deb_package.sh

# tail -f $HOME/projects/cura-lulzbot/Projects/cura/build-master/build/cura-lulzbot_build.log

cd && sudo dpkg -i  ~/projects/cura-lulzbot/Projects/cura/build-master/build/cura-lulzbot-3.6.19-Linux.deb
```
