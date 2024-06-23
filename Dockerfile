# This builds the base image for the Gazebo Harmonic Docker image.
# It patches out optix from the rendering plugin to avoid console warnings.

# Stage 1: Base system setup
FROM ubuntu:22.04 AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    lsb-release \
    gnupg \
    curl \
    git \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Stage 2: Python 3.11 installation, Pybind11 2.12.0, psutil and pyparsing
FROM base AS python311
RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y python3.11 python3.11-dev python3.11-venv python3.11-distutils \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://bootstrap.pypa.io/get-pip.py | python3.11 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && update-alternatives --set python3 /usr/bin/python3.11 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 \
    && update-alternatives --set python /usr/bin/python3.11
# Install pybind11 2.12.0 for Python 3.11
RUN python3.11 -m pip install pybind11==2.12.0
# Verify pybind11 installation
RUN python3.11 -c "import pybind11; print(pybind11.__version__)"
# Set environment variable for pybind11 CMake files
ENV pybind11_DIR=/usr/local/lib/python3.11/dist-packages/pybind11/share/cmake/pybind11
# Install psutil and pyparsing
RUN python3.11 -m pip install psutil pyparsing

# Stage 3: Tool installation
FROM python311 AS tools
RUN python -m pip install vcstool colcon-common-extensions
ENV PATH="/root/.local/bin:${PATH}"

# Stage 4: Repository setup
FROM tools AS repos
RUN curl https://packages.osrfoundation.org/gazebo.gpg -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN apt-get update

# Stage 5: Source download
FROM repos AS source
WORKDIR /root/workspace/src
RUN curl -O https://raw.githubusercontent.com/gazebo-tooling/gazebodistro/master/collection-harmonic.yaml \
    && vcs import < collection-harmonic.yaml

# Stage 6: Dependency installation
FROM source AS deps
WORKDIR /root/workspace/src
RUN apt -y install $(sort -u $(find . -iname 'packages-'`lsb_release -cs`'.apt' -o -iname 'packages.apt' | grep -v '/\.git/') | sed '/gz\|sdf/d' | tr '\n' ' ')

# Stage 7: Apply Patches
FROM deps AS patches
COPY patches/gz-rendering-disable-optix.patch \
    patches/gz-math.patch \
    patches/gz-transport.patch \
    patches/gz-sim.patch \
    patches/sdformat.patch \
    /root/workspace/

RUN patch -p0 -d /root/workspace/src/gz-math < /root/workspace/gz-math.patch
RUN patch -p0 -d /root/workspace/src/gz-transport < /root/workspace/gz-transport.patch
RUN patch -p1 -d /root/workspace/src/gz-sim < /root/workspace/gz-sim.patch
RUN patch -p1 -d /root/workspace/src/sdformat < /root/workspace/sdformat.patch
RUN patch -p0 -d /root/workspace/src/gz-rendering < /root/workspace/gz-rendering-disable-optix.patch

# Stage 8: Remove Python 3.10 remnants
FROM patches as remove_python310
RUN rm -rf /usr/bin/python3.10*
# Verify Python version
RUN python --version

# Stage 9: Build gazebo libraries
FROM remove_python310 AS build
WORKDIR /root/workspace
RUN colcon build --merge-install --cmake-args -DBUILD_TESTING=OFF

# Stage 10: Prepare python wheel
FROM build AS python_wheel
# Copy python_package into workspace
COPY python_package /root/workspace/python_package
WORKDIR /root/workspace
# Copy the python bindings (all files and folders) into the python_package/src dir
RUN cp -r /root/workspace/src/lib/python/* /root/workspace/python_package/src
# Run build
RUN python -m build /root/workspace/python_package

CMD ["/bin/bash"]