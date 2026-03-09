import serial

# Open serial port
ser = serial.Serial('/dev/ttyS0', baudrate=9600, timeout=1)

while True:
    data = ser.readline().decode('ascii', errors='replace')
    print(data)
