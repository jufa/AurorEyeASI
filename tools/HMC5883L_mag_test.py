"""
Minimal HMC5883L driver (MVP)
Reads raw X, Y, Z magnetometer values over I2C.

Tested assumptions:
- smbus / smbus2 compatible bus object
- I2C address 0x1E
"""
import time
import smbus

class HMC5883L:
    # I2C address
    ADDRESS = 0x1E

    # Registers
    CONFIG_A   = 0x00
    CONFIG_B   = 0x01
    MODE       = 0x02
    DATA_START = 0x03  # X_MSB

    STATUS     = 0x09

    # Status bits
    STATUS_DRDY = 0x01

    def __init__(self, bus, address=ADDRESS):
        self.bus = bus
        self.address = address
        self._init_device()

    def _init_device(self):
        """
        Minimal sane configuration:
        - 8-sample average
        - 15 Hz data rate
        - normal measurement
        - +/- 1.3 Gauss gain
        - continuous mode
        """
        # Config A: 0b01110000
        #   01 1 100 00
        #   OS=8, Rate=15Hz, Normal bias
        self.bus.write_byte_data(self.address, self.CONFIG_A, 0x70)

        # Config B: gain = +/-1.3 Ga
        self.bus.write_byte_data(self.address, self.CONFIG_B, 0x20)

        # Mode: continuous
        self.bus.write_byte_data(self.address, self.MODE, 0x00)

    @staticmethod
    def _to_signed(val):
        """Convert unsigned 16-bit to signed"""
        if val >= 32768:
            val -= 65536
        return val

    def read_xyz(self):
        """
        Returns (x, y, z) or None if data not ready
        """
        status = self.bus.read_byte_data(self.address, self.STATUS)
        if not (status & self.STATUS_DRDY):
            return None

        # Read 6 bytes starting at X_MSB
        data = self.bus.read_i2c_block_data(self.address, self.DATA_START, 6)

        x = self._to_signed((data[0] << 8) | data[1])
        z = self._to_signed((data[2] << 8) | data[3])
        y = self._to_signed((data[4] << 8) | data[5])

        return x, y, z

if __name__ == "__main__":
    bus = smbus.SMBus(1)  # Raspberry Pi / Linux I2C-1
    mag = HMC5883L(bus)

    while True:
        xyz = mag.read_xyz()
        if xyz:
            print("X Y Z:", xyz)
        time.sleep(0.4)
        
