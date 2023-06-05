# Use latest Python runtime as a parent image
FROM python:3.6.5-slim

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
# install the requirements in the virtual environment
RUN python3 -m venv ml-env &&\
            . ml-env/bin/activate &&\
            pip --no-cache-dir install --upgrade pip &&\
            pip --no-cache-dir install -r /app/requirements.txt


# Make port 9999 available to the world outside this container
EXPOSE 9999

# Create mountpoint
VOLUME /app

# Run jupyter when container launches
CMD ["jupyter", "notebook", "--ip='0.0.0.0'", "--port=9999", "--no-browser", "--allow-root"]

