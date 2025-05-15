# AurorEyeASI
see [AurorEye.ca](https://auroreye.ca)

## Contact
jeremy@jufaintermedia.com or in this repository as an issue

## Terms
- The content of this repository is for non commercial use
- If you are part of an educational or scientific institution (museum, university, government research agency) please contact the repository manager jeremy@jufainteredia.com
- If your work using the repository leads to improvements to the hardware and software, please consider contributing these back to the repository on a feature branch
- If there is a publication about your AurorEye build or resulting data, please contact jeremy@jufainteredia.com for citation details

## Warranty
All information is provided as-is and without warranty. The user of this software, hardware, and components does so at their own risk and assumes all liability.

## Hardware
The current version of the hardware minimizes power switching/conditioning by using a battery pack with pass through charging, suitable output and charge ports and a status display. An alternate version using a LiFePo4 pack is listed below.

### Bill of Materials
#### Version A
| Component                        | Qty | Description                                                                                                                                                                                                 |
|----------------------------------|-----|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Ball head tripod with arca-swiss mount              | 1   | [Example](https://www.amazon.ca/dp/B0B1HYVVTV)   
| Camera                           | 1   | Sony ZV-E10 Mark I (Mark II is the current version, it is untested in this application at this time)                                                                                                       |
| Lens                             | 1   | Meike 6.5mm f/2.0 circular fisheye for Sony, [Example](https://www.amazon.ca/MEKE-Circular-Fisheye-Digital-Cameras) E-Mount                                                                                                                                                         |
| Controller                       | 1   | Raspberry Pi 3B+ (Should probably move to a RPi 5 with 4GB RAM)                                                                                                                                             |
| OS Storage                       | 1   | 32GB MicroSD card, SanDisk 32GB Ultra or similar                                                                                                                                                           |
| External Storage                 | 1   | SanDisk 256GB Ultra Fit USB 3.1 Flash Drive - [SDCZ430-256G-G46](https://www.amazon.ca/dp/B07857Y17V)                                                                                                       |
| Hotspot WiFi                     | 1   | TP-Link USB A dongle (AC1300 chipset), e.g. TP-Link AC1300 USB WiFi Adapter (Archer T3U) or other AC1300-based dongle                                                                                      |
| Accelerometer Board              | 1   | MPU-6050 Acceleration Sensor 3 axis with I2C interface – [Example](https://www.amazon.ca/dp/B07V67DQ5N)                                                                                                     |
| Magnetometer Board               | 1   | GY-271 QMC5883L Triple Axis Compass Magnetometer Sensor – [Example](https://www.amazon.ca/dp/B09F3LHNB3)                                                                                                    |
| Interface                        | 4   | 12mm Momentary Push Button Switch – [Example](https://www.amazon.ca/dp/B0D874KSJ5)                                                                                                                         |
| Battery Pack                     | 1   | UGREEN 20000mAh Power Bank 130W 3-Port Fast Charger with TFT Display (alt: Anker Prime 27650mAh 3-Port 250W) – model A1340                                                                                 |
| Dummy Battery Pack Adapter       | 1   | Neewer DC Coupler Replacement for NP-FW50 Dummy Battery Power Adapter or similar                                                                                                                           |
| OLED Display                     | 1   | OLED 128x64 Pixel – I2C – 1.3 inch – SSD1306 or SH1106 – [Example](https://www.amazon.ca/dp/B07K7FZ9BZ)                                                                                                     |
| USB-C to USB Adapter             | 2   | USB C to USB Adapter, Type C to USB Adapter                                                                                                                                                                |
| USB-C to USB-A Cable             | 1   | For camera/RPi interconnect                                                                                                                                                                                 |
| USB-C Right Angle Adapter        | 1   | Similar geometry to [this one](https://www.amazon.ca/dp/B0BNMDRWR6?ref_=ppx_hzsearch_conn_dt_b_fed_asin_title_6&th=1)                                                                                      |
| USB-C External Panel Mount Port  | 1   | 0.5m Right Angle USB C 3.1 Male to Female Square Flush Mount Panel Cable or similar                                                                                                                        |
| USB-A Direction Reversers        | 1   | Similar to [this one](https://www.amazon.ca/dp/B0BN9QPB5W)                                                                                                                                                 |
| Ball Mount Tripod Interface      | 1   | 70mm Quick Release Plate Fits Arca-Swiss – [Example](https://www.amazon.ca/dp/B0725S67MM)                                                                                                                  |
| Case/Shell                       | 1   | Nanuk 905 (904 is a tight fit) – [Link](https://nanuk.com/products/nanuk-905)                                                                                                                              |
| Custom PCB Hat                   | 1   | Breakout for several I2C devices, UART; 2-layer PCB. Contact Repository Owner for this unpopulated board. COTS alternate: [Seeed Studio 103030275](https://www.digikey.ca/en/products/detail/seeed-technology-co-ltd/103030275/9771826)                         |
| External USB-C Charger and associated USB-C to USB-C cable                | 1   | External charger/Power: [Anker USB C Charger (Nano 65W)](https://www.amazon.ca/Anker-Charger-Compact-Foldable-MacBook)   

#### Version B additional Hardware
| Component                    | Qty | Description                                                                                                             |
|------------------------------|-----|-------------------------------------------------------------------------------------------------------------------------|
| Controller                   | 1   | RPi 5 with 4GB RAM                                                                                                      |
| Battery Pack                 | 1   | TalentCell 12V LiFePO4 Battery Pack LF4100                                                                              |
| 5A Rated Step-Down Converter | 1   | [Example](https://www.amazon.ca/dp/B085T73CSD) or similar, used for powering the RPi                                    |
| Case                         | 1   | 3D print (under development)                                                                                            |



