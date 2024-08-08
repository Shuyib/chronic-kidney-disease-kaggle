#!/bin/bash
# This script downloads the chronic kidney disease dataset from kaggle
# change mansoordaku/ckdisease to the dataset you want to download

# This command will exit the script if any command returns a non-zero exit code
set -euo pipefail

# Function to run a command with a timeout

# Check if the kaggle.json file exists
# needed for some datasets
if [ ! -f ~/.kaggle/kaggle.json ]; then
    echo "kaggle.json file not found."
    echo "Please upload the kaggle.json file to the ~/.kaggle/ directory."
    exit 1
fi

# check if kaggle and unzip are installed
for cmd in kaggle unzip; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd could not be found"
        echo "Please install $cmd"
        exit 1
    fi
done

# Try downloading the dataset from kaggle
# Retry 5 times with a 15 second delay in case of failure
echo "Downloading dataset from kaggle"
echo "This may take a few minutes..."
echo "Link: https://www.kaggle.com/mansoordaku/ckdisease"
for i in {1..5}; do
    echo "Attempt $i of 5..."
    if kaggle datasets download -d mansoordaku/ckdisease; then
        echo "Dataset downloaded successfully."
        break
    else
        echo "Attempt $i failed. Retrying in 15 seconds..."
        sleep 15
    fi
done

# Check if the download was successful
if [ ! -f ckdisease.zip ]; then
    echo "Failed to download dataset after 5 attempts. Please try again later."
    exit 1
fi

# Unzip the dataset
# -o option to overwrite the file without prompting
unzip -o ckdisease.zip

# Remove the zip file
rm ckdisease.zip

# Move the dataset to the data folder under original data
# -p option to create the parent directory if it doesn't exist
# -v option for verbose output
mkdir -p -v data/input
mv kidney_disease.csv data/input/

# Print success message and list the files in the data folder
echo "Dataset downloaded successfully and moved to data/input folder"
ls data/input