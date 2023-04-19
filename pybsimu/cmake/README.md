Build this in a manylinux container with e.g.:

    /opt/python/cp38-cp38/bin/python3 -m build --wheel
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ubuntu/lib auditwheel repair dist/pybsimu-0.0.0-cp38-cp38-linux_x86_64.whl 

