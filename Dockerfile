# Use latest Python runtime as a parent image
FROM python:3.10-slim-buster

# Meta-data
LABEL maintainer="Shuyib" \
      description="Docker Data Science workflow: Feature engineering and modelling for the chronic kidney disease dataset."
      
# Set the working directory to /app
WORKDIR /app

# ensures that the python output is sent to the terminal without buffering
ENV PYTHONUNBUFFERED=TRUE

# Copy the current directory contents into the container at /app
COPY . /app

# create a virtual environment and activate it
# combine run and source commands to avoid creating a new layer in the image
# Install dependencies and create a virtual environment
RUN apt-get update && apt-get install -y \
    graphviz \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m venv /app/ml-env \
    && . /app/ml-env/bin/activate \
    && pip --no-cache-dir install --upgrade pip \
    && pip --no-cache-dir install -r /app/requirements.txt

# Make port 9999 available to the world outside this container
EXPOSE 9999

# Create mountpoint
VOLUME /app

# Run jupyter lab when the container launches
# sh -c is used to run multiple commands in a single RUN instruction
# --ip='0.0.0.0' allows external connections to the container
# --port=9999 specifies the port to run the jupyter lab server
# --no-browser disables the automatic opening of the browser
# --allow-root allows the jupyter lab server to run as root
CMD ["sh", "-c", ". ml-env/bin/activate && jupyter lab --ip='0.0.0.0' --port=9999 --no-browser --allow-root"]

