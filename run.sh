#!/bin/bash

# Step 1: Check if Python 3.10 is installed
if ! command -v python3.10 &>/dev/null; then
    echo "Python 3.10 not found. Installing Python 3.10 and pip3..."
    
    # Update package list
    sudo apt update
    
    # Install necessary packages to add repository
    sudo apt install -y software-properties-common wget
    
    # Add the Deadsnakes PPA (for newer Python versions)
    sudo add-apt-repository ppa:deadsnakes/ppa
    
    # Update package list after adding the repository
    sudo apt update
    
    # Install Python 3.10
    sudo apt install -y python3.10
    
    # Install Python 3.10's distutils package (required for installing pip)
    sudo apt install -y python3.10-distutils
    
    # Download and install pip for Python 3.10
    sudo wget https://bootstrap.pypa.io/get-pip.py
    sudo python3.10 get-pip.py
    
    # Install pip package for Python 3
    sudo apt install -y python3-pip
    
    # Clean up the installation file
    rm get-pip.py
    
    echo "Python 3.10 and pip3 have been successfully installed."
else
    echo "Python 3.10 is already installed."
fi

# Verify Python 3.10 and pip3 installation
python3.10 --version
pip3 --version

# Step 2: Install screen if it's not installed
if ! command -v screen &>/dev/null; then
    echo "screen not found, installing..."
    sudo apt-get update
    sudo apt-get install -y screen
else
    echo "screen is already installed."
fi

# Step 3: Loop through each bot directory, install dependencies, and start the bot
# Limiting bots to 50 instead of 100
bots=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" "35" "36" "37" "38" "39" "40" "41" "42" "43" "44" "45" "46" "47" "48" "49" "50")

for bot in "${bots[@]}"
do
    # Check if the bot directory exists
    if [ -d "$bot" ]; then
        # Step 3.1: Install dependencies from the bot's requirements.txt (only for bot 1)
        if [ "$bot" == "1" ]; then
            if [ -f "$bot/requirements.txt" ]; then
                echo "Installing dependencies for bot $bot from $bot/requirements.txt using Python 3.10..."
                pip3 install -r "$bot/requirements.txt"
            else
                echo "ERROR: $bot/requirements.txt not found!"
                exit 1
            fi
        fi

        # Step 3.2: Start the bot in a new screen session using Python 3.10
        echo "Starting bot $bot in a new screen session: $bot"
        screen -dmS "$bot" bash -c "cd $bot && python3.10 main.py; exec bash"
    else
        echo "ERROR: Directory $bot does not exist!"
        exit 1
    fi
done

echo "All bots started in their own screen sessions."
