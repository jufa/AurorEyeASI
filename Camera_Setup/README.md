# Camera Setup
The current version of AurorEye uses the Sony ZV-E10 Mark I camera.
This needs to have some default settings updated to work with the AurorEye software - specific settings that cannot be accessed from the USB control port, and are set up using the camera's on screen menu and back-of-camera buttons.

## Method 1: Copy predefined memory settings file onto SD card then into camera internal memory
0. Ensure camera is at latest Firmware version (2.0.2) [Link to firmware download](https://www.sony.ca/en/electronics/support/e-mount-body-zv-e-series/zv-e10/downloads). Note that the Sony Camera Driver may need to be updated on the host computer that is managing the firmware upgrade as per the instructions at the link
1. Copy the file `CAMPR01N.DAT` to an SD card under the folder path: `[SDCARD ROOT]/PRIVATE/SONY/SETTING/E10/CAMPR01N.DAT` NOTE: if your camera is set to PAL format for video, you may have to change the filename "N" to a "P" for the file to be recognized, or switch the camera to NTSC
3. Insert this SD card into the camera.
4. Make sure the USB-C cable is NOT connected to the camera
5. Power on the camera
6. In the camera menu, navigate to Tab 1, screen 3 `Shoot/Drive Mode`
7. Select item `Shoot Mode`
8. Select `MR1` aka `Recall Camera Set 1` from the vertical menu by pressing the roght side of the back-of-camera disc controller
9. you should see a grid of camera settings with tabs on top in this order `1`, `M1`, `M2` etc. Highlight the second tab labelled `M1`and press the center button. This sets the camera to the predefined settings that you copied to the SD card (good!)
10. This will kick you out into the schooting preview screen. Press the `Menu` Button on the back of the camera to get back to the menu screen on Tab 1, screen 3 `Shoot/Drive Mode`
11. Now navigate to the bottommost menu iem on the same screen: `Camera Set Memory`
12. Ensure the `1` tab on the top of this screen is highlighted (The leftmost tab, NOT `M1`)
13. Press the center button of the navigator ring on the back of camera. This should save the new settings to the INTERNAL memory slot of the Camera. The screen should say `Resgitered`
14. Now go to the top menu item `Shoot Mode` and this time change `M1` to `1` to tell the camera to boot up with these new settings which are now internal to the camera
15. This will kick us out back to the shoting preview/l;iveview screen. In the top left you should see a Camera Icon with a larger `M` to the right of it and a smaller `MR1` below it.
16. ***IMPORTANT STEP: REMOVE THE SD CARD***
17. Now the TOP of the camera: Ensure the camera switch is `ON` before mounting it into the AurorEye.
18. All done!

## Method 2: manually go through all menu screens and set them to match the PDF in this folder
Then save the settings using steps 10 onward above. This does not require you to copy the .DAT settings file to an SD card but can be tedious.

## Note on Sony behavior with saving 
in most cases you will be modifying the camera settings while the camera is connected to the AurorEye. 
 - make sure the AurorEye is done boot equence before changing settings
 - do not unpliug the USB cable when changing settings using camera controls and menu
 - ensure you save the settings once done to Camera Set Memory [1]
 - ensure the camera is using Recall Camera Settings [1]
 - after doing this, turn off the camera with its top plate on/off switch and wait 30 seconds to ensure settings are saved
 - power camera up again
 - now you can power off the AurorEye and the settings should be saved

## Notes on SD card parallel operation
In the case that you want to use your own workflow, you can save RAW file to an SD card inserted in the ZV-E10 with some precautions:
 - The SD card can fill up rapidly, the behaviour of the camera when SD card becaomes full while in capture sequence has not been tested
 - The settings for what files go to which storage media are under the camera menu "PC Remote Operation"
