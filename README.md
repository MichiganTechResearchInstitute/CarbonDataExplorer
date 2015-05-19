Carbon Data Explorer v0.2.2
===========================

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

Installation: Linux
-------------------


The following steps have been tested and verified for **Ubuntu 14.04.2 LTS**.

### Run setup.sh

Before running **setup.sh**, be aware that these are the default/recommended installation paths:

    /usr/local/project/CarbonDataExplorer     #<- where this README.md file lives; repo location
    /usr/local/pythonenv/flux-python-api-env  #<- where the Python virtualenv for flux-python-api lives
    /var/www/flux-client                      #<- where the flux-client web client lives

After cloning this repository to your local system, **cd** into the repo and run
setup:

        ./setup.sh

The **setup.sh** script will install the three submodules (and all associated
dependencies) of the Carbon Data Explorer:

* [flux-python-api](https://github.com/arthur-e/flux-client)
* [flux-server](https://github.com/arthur-e/flux-server)
* [flux-client](https://github.com/arthur-e/flux-python-api)

Each submodule has its own **README.md** that provides details on installation
and deployment, but this **setup.sh** script acts as a standalone installer for
the entire package, all submodules included.
    
    
### Configure Apache

Configure apache for both *flux-client* and *flux-server* using this example configuration as guidance:

        cat ./apache/example.conf

For more details see: **./flux-server/README.md** under *Configuring a Port Proxy with Apache*

Remember to restart apache after making configuration changes:

        sudo service apache2 restart


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Installation: Mac OSX
---------------------

The following steps were tested and verified for **OSX 10.9.5**.

### Set path variables

The following paths are recommended.

Where the repository lives (including this file):

        REPO_PATH=/usr/local/project/CarbonDataExplorer     
    
Where the Python virtualenv for *flux-python-api* lives (if used):

        VENV_PATH=/usr/local/pythonenv/flux-python-api-env 

Where the *flux-client* web client lives (should be a web-accessible directory):

        CLIENT_PATH=/Library/WebServer/Documents

### Install Git and clone repository

1. Download & install **Git** from [here](http://git-scm.com/download/mac)

2. Setup **Git** following [instructions here](https://help.github.com/articles/set-up-git)

3. Clone source code from the repository:

            cd $REPO_PATH
            git clone --recursive https://github.com/arthur-e/CarbonDataExplorer.git ./
        
    Older versions of **Git** may require that the submodules are initialized separately with the following command (if the repository's submodule directories- i.e. *flux-python-api*, *flux-client*, and *flux-server*- are empty, do this):

            git submodule update --init --recursive

### Install system dependencies

1. Download & install **Node.js** & **NPM** for Mac from [here](http://nodejs.org/download/)

2. Install **homebrew** with the following command:

            ruby -e "$(curl --insecure -fsSL https://raw.github.com/Homebrew/install/master/install)"

3. Install assorted dependencies:

            brew install wget mongodb geos libxml2 libxslt gcc homebrew/science/hdf5 python

### Install package submodules
    
1. Install *flux-python-api*

    You are encouraged to use a Virtual Environment, which can be set up and activated using these commands:

            sudo pip install virtualenv
            virtualenv $VENV_PATH
            sudo chown -R $USER $VENV_PATH
            source $VENV_PATH/bin/activate
    
    Now run the python installer for *flux-python-api*:
    
            cd $REPO_PATH/flux-python-api
            python setup.py install # <- use 'sudo' ONLY if NOT using a virtualenv
    
    * If the installer ran into errors while installing the Python package dependencies, try installing the most current packages listed in **./flux-python-api/DEPENDENCIES.txt** separately via **pip**, e.g.:
    
                pip install h5py
    
    Once all packages are installed...
    
    * If using virtualenv:
    
                deactivate

    Finally, change some permissions:
    
            sudo chmod -R 777 flux_python_api.egg-info
            sudo chmod -R 777 dist
            sudo chmod -R 777 build/

2. Install *flux-server*:

            cd $REPO_PATH/flux-server/
            sudo ./setup.sh
            npm install
    
3. Install *flux-client*
    
    * Download a pre-built version...:

                sudo curl "ftp://ftp.mtri.org/pub/Flux_Visualizations/flux-client.zip" -o "flux-client.zip"
                sudo unzip flux-client.zip -d $CLIENT_PATH/flux-client/
    
    * ...or if you want to build from source:

                cd $REPO_PATH/flux-client/
                npm install

### Post-install configuration steps

10. Configure Apache for port proxying
  
            cd /etc/apache2/
            sudo cp httpd.conf httpd.conf.bak

     Copy into **httpd.conf** the configuration under *Reverse proxies for CarbonDataExplorer flux-server* in the provided sample apache configuration file:
    
            $REPO_PATH/apache/example.conf

    And then restart Apache:
    
            sudo apachectl restart
    
11. Create **mongoDB** data directory and start mongoDB
  
            sudo mkdir -p /data/db
            sudo mongod
    
    
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    
Quick Start
-----------

After installation on either OS, perform the following steps to get the application up and running.

1. **Load** your data using *flux-python-api* (see **./flux-python-api/docs/index.rst** for more details).

    A small sample dataset is available in **./flux-python-api/fluxpy/tests/**; use the following command to load this sample data and test that *flux-python-api* installed correctly.

    * If using a **virtualenv** (subsitute path to your virtual env not using default):
    
                /usr/local/pythonenv/flux-python-api-env/bin/python ./flux-python-api/manage.py load -p ./flux-path-api/fluxpy/tests/casagfed2004.mat -m SpatioTemporalMatrix -n SAMPLE_casagfed2004

    * If NOT using a **virtualenv**:
    
                python ./flux-python-api/manage.py load -p ./flux-path-api/fluxpy/tests/casagfed2004.mat -m SpatioTemporalMatrix -n SAMPLE_casagfed2004
        
2. **Start** the *flux-server* using this command:

            forever ./flux-server/flux-server.js
    
    Once started, you can test to see if it is working by going to this URL: [http://localhost/flux/api/scenarios.json](http://localhost/flux/api/scenarios.json)
    If you loaded the sample data as instructed above, it should show up in the 
    JSON response given by the URL.
    
    To stop or restart *flux-server*, use these commands:
    
            forever stop flux-server.js
            forever restart 0
    
3. **Go** to [http://localhost/flux-client](http://localhost/flux-client) and check it out!
