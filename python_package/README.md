# Gazebo Python 3.11 bindings
This package contains the Python bindings extracted from the Gazebo project, specifically packaged for use with Python 3.11 on x86_64 Linux distributions.

# Versions
- Gazebo: Harmonic
    - gz-math7
    - gz-transport13
    - gz-sim8
    - gz-common5
    - sdformat14
- Python: 3.11.4
- pybind11: 2.12.0

# Commit Hashes
Please refer to the commit hashes for the Gazebo project for the exact versions used in this package.

| Module         | Commit Hash                           |
|----------------|---------------------------------------|
| gz-cmake       | ddd38ff196640024d6e054ff59cf5fea1ef01d73 |
| gz-common      | 27f7017c5c1b1fd2ba9c603e92b694f98417175d |
| gz-fuel-tools  | e808b0ab580bdf9b413e28ba96a5bede978e5c98 |
| gz-gui         | 1a04fbb127e2e7de7df352a2a915a448f5710231 |
| gz-launch      | 2cb58a1e5add0017dd229f9090aea7614ae18930 |
| gz-math        | 02e37a63e9e24959424e1b2463a6dbe9195a79bb |
| gz-msgs        | 876b89d5cab32d9ddfd5f95ce8cf365ce77f27ef |
| gz-physics     | b5d1508bb7011240d64755506b599c5cd3f18ffa |
| gz-plugin      | e296968d2e4013d9d8c95d31c1f7b4dd5d2e87d8 |
| gz-rendering   | f3d30738726d11d240907e30699ce4c66e8a0f50 |
| gz-sensors     | 4d2ae188117486fbdc4b3a3df3fe25d539a8800d |
| gz-sim         | f024ea83dd26d3711976544a835b74d030cccdb0 |
| gz-tools       | 2b228e5b956f1e966053dd860374670573580b41 |
| gz-transport   | a5af52592810c2aa4f2fec417cc736a18f616e93 |
| gz-utils       | fd618d23156f754726fcd641934d908c766c8f75 |
| sdformat       | fc84f94d147bf31fd594e17bade68946246236b3 |

# Warning
- Please note that this package is specifically designed for Python 3.11 on x86_64 Linux distributions. It is not intended to be a universal distribution and may not function as expected on other Python versions or operating systems.
- Modifications to the CMake scripts were made to support the Python 3.11 build.
- Note the diffs below have been modified to redact personal information.

# Changes made:
All the changes were made to the source in the form of patches, you can find these on the project's github repository under `/patches`.