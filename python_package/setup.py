from setuptools import setup, find_packages

setup(
    name='gz',
    version='1.0.0',
    description='Python 3.11 bindings for Gazebo',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    author='Jc Cloete',
    author_email='jc@truevolve.technology',
    url='https://github.com/Jc-Cloete',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    include_package_data=True,
    package_data={
        'gz': [
            '*.so',
            'msgs10/*.py',
            'transport13/*.so',
            'transport13/*.py'
        ],
    },
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: Apache Software License',
        'Operating System :: POSIX :: Linux',
    ],
    python_requires='>=3.11',
)
