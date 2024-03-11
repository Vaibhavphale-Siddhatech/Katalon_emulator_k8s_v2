# Use a base image with required dependencies
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    openjdk-8-jdk \
    xvfb \
    libxtst6 \
    libxrender1 \
    libxi6 \
    fluxbox \
    x11vnc \
    net-tools \
    socat \
    supervisor \
    android-tools-adb

# Set up Android SDK
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk.zip && \
    unzip android-sdk.zip -d /android-sdk && \
    rm android-sdk.zip && \
    yes | /android-sdk/tools/bin/sdkmanager --licenses && \
    /android-sdk/tools/bin/sdkmanager "platform-tools" "build-tools;28.0.3" "platforms;android-28" "system-images;android-28;google_apis;x86"

# Set up emulator
RUN echo "no" | /android-sdk/tools/bin/avdmanager create avd -n test -k "system-images;android-28;google_apis;x86" --force && \
    echo "hw.keyboard=yes" >> ~/.android/avd/test.avd/config.ini

# Create a startup script
RUN chmod +x /start_emulator.sh

# Expose VNC port
EXPOSE 5900

# Start the emulator when the container runs
CMD ["/start_emulator.sh"]
