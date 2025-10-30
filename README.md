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
#### Version A
| Component                        | Qty | Description                                                                                                                                                                                                 |
|----------------------------------|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Ball head tripod with arca-swiss mount              | 1   | [Example](https://www.amazon.ca/dp/B0B1HYVVTV)   
| Camera                           | 1   | Sony ZV-E10 Mark I (Mark II is the current version, it is untested in this application at this time)                                                                                                       |
| Lens                             | 1   | Meike 6.5mm f/2.0 circular fisheye for Sony, [Example](https://www.amazon.ca/MEKE-Circular-Fisheye-Digital-Cameras) E-Mount                                                                                                                                                         |
| Controller                       | 1   | Raspberry Pi 3B+ (Pi 5 with NVME drive hat and cooling fan is an option too)                                                                                                                                          |
| OS Storage                       | 1   | 32GB MicroSD card, SanDisk 32GB Ultra or similar                                                                                                                                                           |
| External Storage                 | 1   | SanDisk 256GB Ultra Fit USB 3.1 Flash Drive - [SDCZ430-256G-G46](https://www.amazon.ca/dp/B07857Y17V)                                                                                                       |
| Hotspot WiFi                     | 1   | TP-Link USB A dongle (AC1300 chipset), e.g. TP-Link AC1300 USB WiFi Adapter (Archer T3U) or other AC1300-based dongle. one with an external antenna would be more useful fr increasing range                                                                                      |
| Accelerometer Board              | 1   | MPU-6050 Acceleration Sensor 3 axis with I2C interface – [Example](https://www.amazon.ca/dp/B07V67DQ5N)                                                                                                     |
| Magnetometer Board               | 1   | GY-271 QMC5883L Triple Axis Compass Magnetometer Sensor – [Example](https://www.amazon.ca/dp/B09F3LHNB3)                                                                                                    |
| Interface                        | 4   | 12mm Momentary Push Button Switch – [Example](https://www.amazon.ca/dp/B0D874KSJ5)                                                                                                                         |
| Battery Pack                     | 1   | Talentcell LiFePo4 LF4100 battery pack, 76Wh                                                                                |
| 5A Rated Step-Down Converter     | 1   | [Example](https://www.amazon.ca/dp/B085T73CSD) or similar, used for powering the RPi                                    |
| Dummy Battery Pack Adapter       | 1   | Neewer DC Coupler Replacement for NP-FW50 Dummy Battery Power Adapter or similar                                                                                                                           |
| OLED Display                     | 1   | OLED 128x64 Pixel – I2C – 1.3 inch – SSD1306 or SH1106 – [Example](https://www.amazon.ca/dp/B07K7FZ9BZ)                                                                                                     |                                                                                                                                                          
| USB-C to USB-A Cable             | 1   | For camera/RPi interconnect                                                                                                                                                                                 |
| Ball Mount Tripod Interface      | 1   | 70mm Quick Release Plate Fits Arca-Swiss – [Example](https://www.amazon.ca/dp/B0725S67MM)                                                                                                                  |                                                                                                                           |
| Custom PCB Hat                   | 1   | Breakout for several I2C devices, UART; 2-layer PCB. Contact Repository Owner for this unpopulated board. COTS alternate: [Seeed Studio 103030275](https://www.digikey.ca/en/products/detail/seeed-technology-co-ltd/103030275/9771826)                         |
| Power cable for battery pack     | 1   | Male to DC 4.0x1.7mm 90 Degree Angle Barrel Jack Power Cable with bare 2-wire at other end - [Example](https://www.amazon.ca/dp/B0D4J783D2) |
| terminal block accessories       | 1   | 5mm Pitch 2 Pin & 3 Pin PCB Mount Screw Terminal Block - [Example](https://www.amazon.ca/KeeYees-60pcs-Terminal-Connector-Arduino/dp/B07H5G7GC6) |
| Case, 3D Printed, PETG           | 1   | 3D printer capable of printing with 0.4mm nozzle diameter, 0.2-0.28mm layer height, PETG, example, Bambu labs A1 with default print plate and nozzle |
| Brass or aluminum wire, 3mm      | 1   | Approx 60mm for hinge pin |



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



