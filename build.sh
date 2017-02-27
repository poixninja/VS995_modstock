export LOCALVERSION="-vs995.10j.modStock-0.1beta"
export KBUILD_BUILD_USER=poixninja
export KBUILD_BUILD_HOST=nowhere
export ARCH=arm64
export CROSS_COMPILE=/home/nick/VS995-10j/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-
DIR=$(pwd)
BUILD="$DIR/build"
OUT="$DIR/out"
NPR=`expr $(nproc) + 1`

echo "cleaning build..."
if [ -d "$BUILD" ]; then
rm -rf "$BUILD"
fi
if [ -d "$OUT" ]; then
rm -rf "$OUT"
fi

echo "setting up build..."
mkdir "$BUILD"
make O="$BUILD" elsa_vzw-perf_defconfig

echo "building kernel..."
make O="$BUILD" -j$NPR

echo "building moduels"
make O="$BUILD" INSTALL_MOD_PATH="." INSTALL_MOD_STRIP=1 modules_install
rm $BUILD/lib/modules/*/build
rm $BUILD/lib/modules/*/source

mkdir -p $OUT/modules
mv "$BUILD/arch/arm64/boot/Image.lz4-dtb" "$OUT/Image.lz4-dtb"
find "$BUILD/lib/modules/" -name *.ko | xargs -n 1 -I '{}' mv {} "$OUT/modules"

echo "Image.lz4-dtb and modules can be found in $OUT"


