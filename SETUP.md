# Multistep commissioning

## Sub systems testing
Do these before interconnecting subsystems:
 - Keep buck converter output detached from all downstream electronics. Power up with 9VDC input voltage, adjust to output 5.2 VDC out.
 - Power up Raspberry Pi using a benchtop power supply or its USB power input. Attach HDMI Monitor and USB-A keyboard to note any errors during boot.
 - test camera with internal battery. Set menu system to allow 'PC Remote' access over USB as per [ZV-E10 manual](https://helpguide.sony.net/ilc/2070/v1/en/contents/TP0002392805.html)
 - test that camera dummy battery outputs 8.2 VDC when powered via its USB A input
 - test thaty dummey battery allows camera to power up Camera
 - leave camera top plate power switch to 'on'
 - attach camera to Pi via usb-C to usb-A data cable (not power-only; ensure data is supported)
   
## setting up SSH for network login:
run `./tools/pi-config/ssh_key_setup_run_once.sh` and follow instructions

# USB-A Thumb/SSD Drive
 - This may need to be mounted and formatted properly before the system can boot as each SSD drive has a different UUID at a OS level to mount successfully.
 - use `./tools/pi-config/setup_extstore.sh` tool to setup extstore with SSD thumbdrive installed in a USB port.

# I2C component tests
If RPI boots into command line, and you have logged in,:
enter into command line prompt:
`i2c-detect -y 1'
Look for these dvices to be listed in the detection grid:
```
0x1e - HMC5583 magnetometer built into BN-880 compass/GPS module OR:
0x0d - QMC5583 magnetometer if included as separate module board
0x3c - SSD1306 OLED display
0x68 - Accellerometer board
```

# GPS communication over serial
 - the GPS communicates over /dev/serial0 or /dev/ttyUSB0
 - check that `sudo tail -f /dev/ttyUSB0` or `sudo tail -f /dev/serial0` is relaying NMEA sentences, note that it may auto adapt its baud rate and return unparsable ASCII

# Camera detection
 - if booting succeeds, you can check if camera is detected:
 - command line: `gphoto2 --autot-detect` should list the ZV-E10 on a USB port

# AurorEye log file
 - the AurorEye software will attempt to log during boot to /mnt/extstore/auroreye_log.txt
 - `tail -f /mnt/extstore/auroreye_log.txt` in a separate terminal window to monitor errors and logging can help with comissioning and monitoring






