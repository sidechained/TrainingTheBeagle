#!/bin/sh
# - bash script which starts audio (jack), runs a SuperCollider patch and a Python script
# - output is logged to a file (to aid troubleshooting)

sudo exec > /tmp/vase.txt 2>&1
echo $(date)
echo "running sclang postbootscript..."
echo "starting jack..."
jackd -dalsa -dhw:1,0 -p512 -n3 -s &
sleep 4
echo "start supercollider..."
sclang /home/debian/initScript/autostart.scd &
sleep 4
echo "starting python..."
sudo python /home/debian/initScript/autostart.py