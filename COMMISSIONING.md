1. Configure the camera as per camera_config/README.md
2. Check that software is running by turning on computer with our without camera connected. OLED should chow logho and boot sequence screen, finishing with a display of ISO and exposure time and GPS data
3. Verify GPS reporting on OLED
4. Verify accelerometer is reporting on the 'LEVEL' screen
5. Verfify camera can be powered up from the dummy battery
6. Verify camera is set to memory slot [M1] and camera configuration steps have been followed in /camera_setup
7. Power off system
8. Connect camera to the RPI via usb-C to usb-a cable
9. Ensure power switch on top of camera is set to ON
10. Power up computer and sensors
11. Check that camera is detected on OLED display (verify under 'SETTINGS' menu for a message like "NO ERRORS". If the camera is not detected, there will be a USB error message
12. Optional for debug/monitoring: inspect the log file using tail -f /mnt/extstore/auroreye_log.txt via your ssh connection to the unit
13. Wait for GPS time lock on main OLED status screen
14. Start a sequence using the START button and see if images are captured.
15. check that the sequence(s) are stored in /mnt/extstore as folders with the sequence start time: i.e. seq_YYYY-MM-DDTHH-MM-SS
16. From a remote computer you can select and download sequences using [https://github.com/jufa/AurorEyeASI/blob/main/tools/fetch_sequence.ssh] (Linux/Mac tested) 
