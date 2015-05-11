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

(cd ./flux-client/ && ./setup.sh)

# Done.
echo -en "\n\nCarbonDataExplorer installation complete!"
