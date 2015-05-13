Carbon Data Explorer v0.2.2
----------------------------------

################
# Installation #
################

    $ ./setup.sh

The setup.sh script will install the three submodules (and all associated
dependencies) of the Carbon Data Explorer:

* flux-python-api
* flux-server
* flux-client

Each submodule has itsown README.md that provides details on installation and
deployment, but the above setup.sh script is intended to be used as a standalone
installer for the entire package, all submodules included.

### Recommended/default directory paths for installation:

/usr/local/project/CarbonDataExplorer     <- [where this file lives (w/ its neighboring files/folders)]
/usr/local/pythonenv/flux-python-api-env  <- [where the Python virtualenv for flux-python-api lives]
/var/www/flux-client                      <- [where the built flux-client web client lives]

### Once the setup.sh script completes, follow these steps to complete setup:

1. Configure apache for both *flux-client* and *flux-server* using the configuration suggested under:
    $ ./apache/example.conf
(for more details see: ./flux-server/README.md under 'Configuring a Port Proxy with Apache')

2. Load your data using *flux-python-api* (see ./flux-python-api/README.md for details).
A small sample dataset is available in ./flux-python-api/fluxpy/tests/; use the following command to load the sample data and test that flux-python-api installed correctly:
    $ /usr/local/pythonenv/flux-python-api-env/bin/python ./flux-python-api/manage.py load -p ./flux-path-api/fluxpy/tests/casagfed2004.mat -m SpatioTemporalMatrix -n casa_gfed_2004

3. Start the *flux-server* using this command:
    $ forever ./flux-server/flux-server.js

4. Go to http://localhost/flux-client and check it out!
