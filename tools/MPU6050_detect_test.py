import smbus2

MPU6050_ADDRESS = 0x68
PWR_MGMT_1 = 0x6B

try:
    bus = smbus2.SMBus(1)
    bus.write_byte_data(MPU6050_ADDRESS, PWR_MGMT_1, 0)  # Wake up MPU6050
    print("MPU6050 detected and initialized.")
except Exception as e:
    print(f"Error: {e}")