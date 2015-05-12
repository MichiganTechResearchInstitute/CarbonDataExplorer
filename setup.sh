VIRTUALENVPATH="/usr"

# Step 1. Install flux-python-api
echo -en "\nInstalling submodule: flux-python-api...\n-----------------------------------\n\n"

while true; do
    read -p "Install flux-python-api using virtual environment (recommended)? (y/n) " yn
    case $yn in
        [Yy]* ) sudo apt-get install python-virtualenv;
                read -e -p "Enter desired path to virtual env: " -i "/usr/local/pythonenv/flux-python-api-env" VIRTUALENVPATH;
                virtualenv $VIRTUALENVPATH;
                source $VIRTUALENVPATH/bin/activate;
                break;;
        [Nn]* ) echo "Not using virtualenv..."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

(cd ./flux-python-api/ && python setup.py install)


# Step 2. Install flux-server
echo -en "\n\nInstalling submodule: flux-server...\n-----------------------------------\n\n"

sudo apt-get install nodejs nodejs-legacy
sudo apt-get install npm
sudo chmod ug+x ./flux-server/setup.sh
sudo ./flux-server/setup.sh
(cd ./flux-server/ && sudo npm install)


# Step 3. Install flux-client
echo -en "\n\nInstalling submodule: flux-client...\n-----------------------------------\n\n"

while true; do
    read -p "Install pre-built version of flux-client? (y/n) " yn
    case $yn in
        [Yy]* ) sudo wget ftp://ftp.mtri.org/pub/Flux_Visualizations/flux-client.zip; sudo unzip flux-client -d /var/www/CarbonDataExplorer;
                echo -en "\nBuilt version of flux-client has been installed to: /var/www/CarbonDataExplorer\n\nThe client can be accessed at: http://localhost/CarbonDataExplorer"
                break;;
        [Nn]* ) echo "You answered 'no'; flux-client will need to be built from source; consult ./flux-client/README.md for detailed instructions."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Done.
echo -en "\n\nCarbonDataExplorer installation complete!"
echo -en "\n\n******FOLLOW THESE REMAINING STEPS TO COMPLETE SETUP******\n\n1. Make sure to configure apache as instructed in ./flux-server/README.md under 'Configuring a Port Proxy with Apache'\n\n2. Load your data. Sample data is available in ./flux-python-api/fluxpy/tests/. Command to load the sample data:
$VIRTUALENVPATH/bin/python ./flux-python-api/manage.py load -p ./flux-path-api/fluxpy/tests/casagfed2004.mat -m SpatioTemporalMatrix -n casa_gfed_2004\n\n3. Start the flux-server:\nforever ./flux-server/flux-server.js\n\n4. Go to http://localhost/CarbonDataExplorer and check it out!\n\n"
