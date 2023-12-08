#!/bin/bash

echo
echo "--------------------------------------"
echo "        Evolution X 14.0 Build        "
echo "                  by                  "
echo "               Kelexine               "
echo "         Origin author: ponces        "
echo "--------------------------------------"
echo

set -e

BL=$PWD/EvolutionX_GSI
BD=$PWD/EvolutionX_GSI/GSI

initRepos() {
    if [ ! -d .repo ]; then
        echo "--> Initializing workspace"
        repo init -u https://github.com/Evolution-X/manifest -b udc --depth=1
        echo

        echo "--> Preparing local manifest"
        mkdir -p .repo/local_manifests
        cp $BL/manifest.xml .repo/local_manifests/evo.xml
        echo
    fi
}

syncRepos() {
    echo "--> Syncing repos"
    repo sync -c --force-sync --no-clone-bundle --no-tags  -j$(nproc --all)
    echo
}

applyPatches() {
    echo "--> Applying phh patches"
    bash $BL/apply-patches.sh $BL phh
    echo

    echo "--> Applying misc patches"
    bash $BL/apply-patches.sh $BL misc
    echo

    echo "--> Generating makefiles"
    cd device/phh/treble
    cp $BL/evo.mk .
    bash generate.sh evo
    cd ../../..
    echo
}

setupEnv() {
    echo "--> Setting up build environment"
    source build/envsetup.sh &>/dev/null
    mkdir -p $BD
    echo
}

buildTrebleApp() {
    echo "--> Building treble_app"
    cd treble_app
    bash build.sh release
    cp TrebleApp.apk ../vendor/hardware_overlay/TrebleApp/app.apk
    cd ..
    echo
}

buildVariant() {
    echo "--> Building treble_a64_bgN"
    lunch treble_a64_bgN-userdebug
    make -j$(nproc --all) installclean
    make -j$(nproc --all) systemimage
    mv $OUT/system.img $BD/system-treble_a64_bgN.img
    echo
}

buildMiniVariant() {
    echo "--> Building treble_a64_bgN-mini"
    (cd vendor/evolution && git am $BL/patches/mini.patch)
    make -j$(nproc --all) systemimage
    (cd vendor/evolution && git reset --hard HEAD~1)
    mv $OUT/system.img $BD/system-treble_a64_bgN-mini.img
    echo
}

buildPicoVariant() {
    echo "--> Building treble_a64_bgN-pico"
    (cd vendor/evolution && git am $BL/patches/pico.patch)
    make -j$(nproc --all) systemimage
    (cd vendor/evolution && git reset --hard HEAD~1)
    mv $OUT/system.img $BD/system-treble_a64_bgN-pico.img
    echo
}

generatePackages() {
    echo "--> Generating packages"
    buildDate="$(date +%Y%m%d)"
    xz -cv $BD/system-treble_a64_bgN.img -T0 > $BD/evolution_a64-ab-8.0.3-unofficial-$buildDate.img.xz
    xz -cv $BD/system-treble_a64_bgN-mini.img -T0 > $BD/evolution_a64-ab-mini-8.0.3-unofficial-$buildDate.img.xz
    xz -cv $BD/system-treble_a64_bgN-pico.img -T0 > $BD/evolution_a64-ab-pico-8.0.3-unofficial-$buildDate.img.xz
    rm -rf $BD/system-*.img
    echo
}

generateOta() {
    echo "--> Generating OTA file"
    version="$(date +v%Y.%m.%d)"
    timestamp="$START"
    json="{\"version\": \"$version\",\"date\": \"$timestamp\",\"variants\": ["
    find $BD/ -name "evolution_*" | sort | {
        while read file; do
            filename="$(basename $file)"
            if [[ $filename == *"mini"* ]]; then
                name="treble_a64_bgN-mini"
            elif [[ $filename == *"pico"* ]]; then
                name="treble_a64_bgN-pico"
            else
                name="treble_a64_bgN"
            fi
            size=$(wc -c $file | awk '{print $1}')
            url="https://github.com/kelexine/EvolutionX_GSI/releases/download/$version/$filename"
            json="${json} {\"name\": \"$name\",\"size\": \"$size\",\"url\": \"$url\"},"
        done
        json="${json%?}]}"
        echo "$json" | jq . > $BL/ota.json
    }
    echo
}

START=$(date +%s)

initRepos
syncRepos
applyPatches
setupEnv
buildTrebleApp
buildVariant
buildMiniVariant
buildPicoVariant
generatePackages
generateOta

END=$(date +%s)
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))

echo "--> Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo
