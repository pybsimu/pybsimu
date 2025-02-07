# pybsimu
pybsimu is a wrapper for [IBSimu](https://ibsimu.sourceforge.net/), an ion beam simulator written by Taneli Kalvas. This package was developed by [Avlanache Energy](https://avalanchefusion.com/). Unfortunately, due to limited bandwidth, the maintenance and support of this code base will be limited. In addition, not every aspect of IBSimu has been ported over, so some features may be missing. 

Before running IBSimu, docker must be installed [link](https://docs.docker.com/engine/install/) to build the environment necessary. A working knowledge of docker is extremely helpful as well. 

# Building docker image

Once docker is installed and this repository has been cloned locally, in any terminal navigate to this repository and run the following command:


```docker build -t <image_name> -f Dockerfile.pybsimu .```

This will build the image locally and may take several minutes. 

# Starting docker container

```cd my_model_source_directory```

```docker run -it -v `pwd`:/host libibsimu-dev bash```

```docker start libibsimu-dev ```

```docker exec -it libibsimu-dev bash```

# Building model in the container, requires existing libibsimu Makefile

```cd /host```
```make```

# Using vscode as a development environment with the container

Use the Visual Studio Code Dev Containers extension, point it at the container you started above. There is an option for the path to point it at, point it at the root of the filesystem, '/'.

Then for intellisense to work, you'll need to 'Edit includePath setting', and add the following:

```/home/ubuntu/include/**```

You can get to the 'Edit includePath setting' by either using the "C/Cpp: Edit Configurations" command in the command palette or by selecting "Edit "includePath" setting" in the light bulb menu

This is based on this super helpful post:   https://andrey-shornikov.medium.com/ibsimu-simulation-package-in-a-docker-container-b14203aa57b0

# TODO: cleanup

ibsimu_config.sh is in the model directory, need to move it into the dev image.
```
# sh ibsimu_config/ibsimu_config.sh
# source ~/.bashrc
```
