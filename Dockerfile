FROM ubuntu:16.04
MAINTAINER Efa-GmbH <team@efa-gmbh.com>

# Copy installation scripts in
COPY *.sh ./

# Prepare the system
RUN ./setup.sh
# Install dependencies
RUN ./dependencies.sh
# Install extras
RUN ./extras.sh
# Install libsrtp 2.0.0 (To reduce risk of broken interoperability with future WebRTC versions)
RUN ./libsrtp.sh
# Install usrsctp for data channel support
RUN ./usrsctp.sh
# Install websocket dependencies
RUN ./websockets.sh

# Copy the apache configuration files ready for when we need them
COPY apache2/*.conf ./
# Install and prepare apache
RUN ./apache.sh

# Put configs in place
COPY conf/* /opt/janus/etc/janus/

# Clone, build and install the gateway
RUN ./janus.sh

# Declare the ports we use
EXPOSE 80 8088 8188

# Define the default start-up command
CMD ./startup.sh
