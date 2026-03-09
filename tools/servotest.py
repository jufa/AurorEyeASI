import RPi.GPIO as GPIO
import time

# Set up GPIO
GPIO.setmode(GPIO.BCM)  # Use Broadcom pin numbering
servo_pin = 18  # GPIO pin connected to the servo signal wire

GPIO.setup(servo_pin, GPIO.OUT)

# Set up PWM
pwm = GPIO.PWM(servo_pin, 50)  # 50Hz frequency (20ms period, suitable for most servos)
pwm.start(0)  # Start with PWM signal off

def set_servo_angle(angle):
    """
    Set the servo to a specific angle.
    :param angle: Desired angle (0 to 180)
    """
    duty_cycle = 2 + (angle / 18)  # Convert angle to duty cycle
    pwm.ChangeDutyCycle(duty_cycle)
    time.sleep(0.5)  # Allow time for the servo to reach the position
    pwm.ChangeDutyCycle(0)  # Prevent jitter by stopping the PWM signal

try:
    while True:
        angle = float(input("Enter angle (0-180): "))
        if 0 <= angle <= 180:
            set_servo_angle(angle)
        else:
            print("Please enter a valid angle between 0 and 180.")
except KeyboardInterrupt:
    print("\nExiting program.")
finally:
    pwm.stop()
    GPIO.cleanup()  # Clean up GPIO to avoid warnings


