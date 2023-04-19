CC = g++
SWIG = /usr/bin/swig3.0
LDFLAGS = `pkg-config --libs ibsimu-1.0.6dev`
CXXFLAGS = -Wall -O3 -g `pkg-config --cflags ibsimu-1.0.6dev`

_pybsimu.so: pybsimu_wrap.o
	$(CC) -shared pybsimu_wrap.o /home/ubuntu/lib/libibsimu-1.0.6dev.so -o _pybsimu.so

pybsimu_wrap.o: pybsimu_wrap.cxx
	$(CC) -c -fpic -I/usr/include/python3.8 -I/home/ubuntu/include/ibsimu-1.0.6dev $(CXXFLAGS) pybsimu_wrap.cxx $(LDFLAGS)

pybsimu_wrap.cxx pybsimu.py: pybsimu.i
	$(SWIG) -c++ -python -threads -o pybsimu_wrap.cxx -D_GNU_SOURCE -DHAVE_SIGINFO_T -DCAIRO_HAS_PNG_FUNCTIONS -I/home/ubuntu/include/ibsimu-1.0.6dev pybsimu.i

clean:
	$(RM) *.o pybsimu_wrap.cxx pybsimu.py _pybsimu.so