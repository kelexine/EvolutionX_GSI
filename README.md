# Evolution X GSI

## Build
To get started with building Evolution X GSI, you'll need to get familiar with [Git and Repo](https://source.android.com/source/using-repo.html) as well as [How to build a GSI](https://github.com/phhusson/treble_experimentations/wiki/How-to-build-a-GSI%3F).
- Create a new working directory for your Evolution X build and navigate to it:
    ```
    mkdir evo; cd evo
    ```
- Clone this repo:
    ```
    git clone https://github.com/kelexine/EvolutionX_GSI.git -b evo
    ```
- Setup Build Tools and Environment
    ```
    sudo apt install bc bison build-essential curl flex g++-multilib gcc-multilib git gnupg gperf libxml2 \
lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-gtk3-dev imagemagick git \
lunzip lzop schedtool squashfs-tools xsltproc zip zlib1g-dev openjdk-8-jdk python3 perl  \
xmlstarlet virtualenv xz-utils rr jq libncurses5 pngcrush lib32ncurses5-dev git-lfs libxml2 \
openjdk-11-jdk-headless
    ```
- Finally, start the build script:
    ```
    bash EvolutionX_GSI/build.sh
    ```
- For a64 builds run the script:
    ```
    bash EvolutionX_GSI/build-a64.sh

## Credits
These people have helped this project in some way or another, so they should be the ones who receive all the credit:
- [Evolution X Team](https://evolution-x.org)
- [Ponces](https://github.com/ponces)
- [phhusson](https://github.com/phhusson)
- [AndyYan](https://github.com/AndyCGYan)
- [eremitein](https://github.com/eremitein)
- [kdrag0n](https://github.com/kdrag0n)
- [Peter Cai](https://github.com/PeterCxy)
- [haridhayal11](https://github.com/haridhayal11)
- [sooti](https://github.com/sooti)
- [Iceows](https://github.com/Iceows)
- [ChonDoit](https://github.com/ChonDoit)
