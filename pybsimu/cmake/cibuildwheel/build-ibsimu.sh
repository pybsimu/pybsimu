
yum -y install cairo-devel gsl-devel gtk3-devel

mkdir /build-ibsimu
cp libibsimu-1.0.6dev_e8500a2.tar.gz /build-ibsimu
cp stlfile.hpp.patch /build-ibsimu
cd /build-ibsimu
tar xzvf libibsimu-1.0.6dev_e8500a2.tar.gz &&\
    cd libibsimu-1.0.6dev_e8500a2 &&\
    patch src/stlfile.hpp < ../stlfile.hpp.patch &&\
    ./configure --enable-sigsegv_stack --prefix=/home/ubuntu &&\
    make &&\
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/atlas make check &&\ 
    make install

