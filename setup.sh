VIRTUALENVPATH="/usr"

# Step 1. Install flux-python-api
echo -en "\nInstalling submodule: flux-python-api...
            -----------------------------------\n\n"

while true; do
    read -p "Install flux-python-api using virtual environment (recommended)? (y/n) " yn
    case $yn in
        [Yy]* ) sudo apt-get install python-virtualenv;
                read -e -p "Enter desired path to virtual env: " -i "/usr/local/pythonenv/flux-python-api-env" VIRTUALENVPATH;
                sudo mkdir -p ${VIRTUALENVPATH%/*};
                sudo virtualenv $VIRTUALENVPATH;
                sudo chown -R $USER $VIRTUALENVPATH;
                source $VIRTUALENVPATH/bin/activate;
                break;;
        [Nn]* ) echo "Not using virtualenv..."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

(cd ./flux-python-api/ && python setup.py install)


# Step 2. Install flux-server
echo -en "\n\nInstalling submodule: flux-server...
              ----------------------------------\n\n"

sudo apt-get install nodejs nodejs-legacy npm
sudo chmod ug+x ./flux-server/setup.sh
sudo ./flux-server/setup.sh
(cd ./flux-server/ && sudo npm install)

while true; do
    read -p "Install apache2 packages required for flux-server & flux-client? (y/n) " yn
    case $yn in
        [Yy]* ) sudo apt-get install apache2 apache2-bin apache2-data apache2-mpm-worker
                sudo a2enmod proxy proxy_http rewrite
                sudo service apache2 restart
                break;;
        [Nn]* ) echo "Not installing apache..."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Step 3. Install flux-client
echo -en "\n\nInstalling submodule: flux-client...
              -----------------------------------\n\n"

while true; do
    read -p "Install pre-built version of flux-client? (y/n) " yn
    case $yn in
        [Yy]* ) sudo mkdir -p /var/www;
                sudo wget ftp://ftp.mtri.org/pub/Flux_Visualizations/flux-client.zip;
                sudo unzip flux-client -d /var/www/flux-client;
                echo -en "\nFlux-client has been installed to: /var/www/flux-client";
                break;;
        [Nn]* ) echo "You answered 'no'; flux-client will need to be built from source; consult ./flux-client/README.md for detailed instructions."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Done.
echo -en "\n
CarbonDataExplorer installation complete!
--------------------------------------------------------------------------------
******FOLLOW THESE REMAINING STEPS TO COMPLETE SETUP******

1. Configure apache for both *flux-client* and *flux-server* using the configuration suggested under:

    $ ./apache/example.conf
    
* For more details see: ./flux-server/README.md under 'Configuring a Port Proxy with Apache')
* Remember to restart apache after making configuration changes:

    $ sudo service apache2 restart

2. Load your data using *flux-python-api* (see **./flux-python-api/README.md** for details).
* A small sample dataset is available in **./flux-python-api/fluxpy/tests/**
* Use the following command to load this sample data and test that *flux-python-api* installed correctly:

    $ /usr/local/pythonenv/flux-python-api-env/bin/python ./flux-python-api/manage.py load -p ./flux-python-api/fluxpy/tests/casagfed2004.mat -m SpatioTemporalMatrix -n SAMPLE_casagfed2004

3. Start the *flux-server* using this command:

    $ forever ./flux-server/flux-server.js

4. Go to **http://localhost/flux-client** and check it out!
"
