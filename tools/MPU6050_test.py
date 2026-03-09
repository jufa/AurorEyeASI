import smbus
import time
import sys

# MPU6050 I2C address
MPU6050_ADDRESS = 0x68

# Register addresses
PWR_MGMT_1 = 0x6B
ACCEL_XOUT_H = 0x3B
ACCEL_YOUT_H = 0x3D
ACCEL_ZOUT_H = 0x3F
TEMP_OUT_H = 0x41
GYRO_XOUT_H = 0x43
GYRO_YOUT_H = 0x45
GYRO_ZOUT_H = 0x47

def read_word(bus, address, reg):
    """Read two bytes from a register and combine them."""
    high = bus.read_byte_data(address, reg)
    low = bus.read_byte_data(address, reg + 1)
    value = (high << 8) | low
    if value > 32768:  # Convert to signed
        value -= 65536
    return value

def main():
    # Initialize I2C bus
    bus = smbus.SMBus(1)
    
    # Wake up MPU6050 (set power management register to 0)
    bus.write_byte_data(MPU6050_ADDRESS, PWR_MGMT_1, 0)

    print("Reading MPU6050 data...")
    
    while True:
        # Read accelerometer data
        accel_x = read_word(bus, MPU6050_ADDRESS, ACCEL_XOUT_H)
        accel_y = read_word(bus, MPU6050_ADDRESS, ACCEL_YOUT_H)
        accel_z = read_word(bus, MPU6050_ADDRESS, ACCEL_ZOUT_H)

        # Read temperature
        temp_raw = read_word(bus, MPU6050_ADDRESS, TEMP_OUT_H)
        temp_c = (temp_raw / 340.0) + 36.53  # Convert to Celsius

        # Read gyroscope data
        gyro_x = read_word(bus, MPU6050_ADDRESS, GYRO_XOUT_H)
        # gyro_y = read_word(bus, MPU6050_ADDRESS, GYRO_YOUT_H)
        # gyro_z = read_word(bus, MPU6050_ADDRESS, GYRO_ZOUT_H)

        # Print data
        # print(f"Accel X: {accel_x}, Y: {accel_y}, Z: {accel_z}")
        sys.stdout.write(f"Accel X: {accel_x}, Y: {accel_y}, Z: {accel_z} Temp: {temp_c:.2f} °C\r")
        sys.stdout.flush()

        # print(f"Gyro X: {gyro_x}, Y: {gyro_y}, Z: {gyro_z}")
        # print("-" * 40)
        
        time.sleep(0.1)

if __name__ == "__main__":
    main()
