# AurorEyeASI
see [AurorEye.ca](https://auroreye.ca)

## Contact
jeremy@jufaintermedia.com or in this repository as an issue

## Terms of Use
Please see LICENSE.md

## Warranty
Please see LICENSE.md

## Hardware
The current version of the hardware minimizes power switching/conditioning by using a battery pack with pass through charging, suitable output and charge ports and a status display. An alternate version using a LiFePo4 pack is listed below.

### Bill of Materials
Please see BOM.md

## 3D Printable Shell
This repository includes and STL file for 3D printing. This replaces the Nanuk 904 OTS hard case, aluminum mount bracket with 3D printable Shell with stackable configurable trays for battery, electronics, camera, and interface. This design integrates a 10mm dead space shell wall to reduce heat leakage has more interior room while maintaining similar external dimensions to the Nanuk 904 case.

This case shell is under active development and a refined version is expected in early November 2025

## Development projects for students, researchers
### Hardware
* Low temperature tolerant LiFePO4 battery pack characterization
* Updates to KiCAD design files for Pi “HAT” circuit board
* Manufacturability considerations (maybe 3D printed internal frame for sensor alignment and support)
* Heat flow/moisture characterization and management (dew point, built-in heaters, condensation prevention for longer periods of deployment)
* 3D printed shell with in-built insulative properties, stackable, modular (in progress now)

### Optics and Sensor Characterization
* Optical characterization (lens, camera, distortion and light falloff parameters)
* Image file transforms (Camera internal color and post processing characterization)
* possible calibration with distortion from a weather cover dome

### Comms and UI
* Test with satellite or cellular Wifi
* Modify cloud upload for appropriate cloud environment (right now it is google cloud)
* UI development (currently a web app which provides flexibility as well as onboard buttons and display)
* Improvements or characterization of camera communication using established open source library (gPhoto2)

### Software/Firmware
* Onboard firmware updates, (branches off of main github repository with new features)
* Post processing tools updates (OpenCV, Python, Davinci Resolve Fusion workflows)
* Archiving, storing, and sharing system website (currently youtube and local backup servers of still image sequences)

### Skill areas for students
* Batteries and power electronics
* Temperature management hardware and sensing
* Magnetometers, Accelerometers for alignment
* Python programming
* Cloud API interface
* GitHub software collaboration
* Image processing and characterization using OpenCV or other open tools
* Image recognition/Machine Learning/AI
* 3D CAD/CAM
* Web Application development
* Video editing for outreach
* Field work campaigning and collaboration between multiple instruments
* Fabrication with Aluminum and Plastic
* Electronics assembly, packaging for harsh environments



