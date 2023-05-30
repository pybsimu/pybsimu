import setuptools

setuptools.setup(
    name='pybsimu',
    version='0.0.1',
    description='A python package wrapper for ibsimu.',
    long_description='A python package wrapper for ibsimu.',
    url='https://github.com/aed-zed/pybsimu',
    packages=['pybsimu'],
    package_data={'pybsimu': ['_pybsimu.so']},
    install_requires=[],
)