#!/bin/bash

# Check if running as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root. Please run with sudo."
  exit 1
fi

# Initialize cam variable
cam_name=""
cam_device=""

# Loop through all devices in /dev matching the pattern
for device in /dev/cam_*; do
  if [ -e "$device" ]; then
    echo "Found device: $device"
		cam_device=$device
    cam_name=${device##*/cam_}
    break
  fi
done

# Check if cam is set
if [ -z "$cam_name" ]; then
  echo "No devices found matching /dev/cam_*"
  exit 1
fi

# Define the content of the service file
SERVICE_CONTENT="[Unit]
Description=the OctoPi(buntu) ustreamer daemon with the user specified config
After=network.online.target
Wants=network.online.target

[Service]
User=orangepi
ExecStart=/home/orangepi/ustreamer/ustreamer --device $cam_device --host=0.0.0.0 --port=8001 --device-timeout 8 --device-error-delay 8 --buffers=3 --workers=3 --drop-same-frame=30 --format=YUYV -r 640x480 -f 0

[Install]
WantedBy=multi-user.target"

# Write the content to the service file
echo "$SERVICE_CONTENT" | sudo tee "/etc/systemd/system/cam_$cam_name.service" > /dev/null

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable and start the service (Optional)
sudo systemctl enable "cam_$cam_name.service"
sudo systemctl start "cam_$cam_name.service"

echo ""
echo "Camera $cam_name stream service patched!"
echo ""
exit 0