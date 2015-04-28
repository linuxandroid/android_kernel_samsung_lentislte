make modules -j4
rm -rf *.ko
find -name '*.ko' -exec cp -av {} . \;
        for i in *.ko; do arm-eabi-strip --strip-unneeded $i;done;\
