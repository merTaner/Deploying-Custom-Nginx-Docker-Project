# Use the latest official Nginx image as the base image
FROM nginx:latest

# Label to specify the maintainer's name and contact information
LABEL maintainer="Mert Taner @m1aner"

# Set an environment variable USERNAME with the value "Mert"
ENV USERNAME="Mert"

# Define a build-time variable COLOR, which can be used to specify a 
# color (or a folder name) during the build process
ARG COLOR

# Update the package list and install useful utilities: curl, htop, wget
RUN apt-get update && apt-get install -y curl htop wget

# Set the working directory to /tempfolder
WORKDIR /tempfolder

# Download the latest WordPress package and add it to the /tempfolder directory
ADD https://wordpress.org/latest.tar.gz .

# Set the working directory to the default Nginx HTML directory
WORKDIR /usr/share/nginx/html 

# Copy files from a subdirectory in 'html/' based on the COLOR argument to the Nginx HTML directory
COPY html/${COLOR}/ .

# Set up a health check to verify that the server is running
# This checks the server every 30 seconds, waits up to 30 seconds for a response,
# starts 5 seconds after the container starts, and retries up to 3 times if it fails
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f https://localhost/ || exit 1

# Specify the default command to run when the container starts
CMD [ "sh", "./script.sh" ]
