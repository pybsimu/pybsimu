# Building docker image

```docker build -t <image_name> -f Dockerfile.pybsimu .```

# Starting docker container

```cd my_model_source_directory```

```docker run -it -v `pwd`:/host libibsimu-dev bash```

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
