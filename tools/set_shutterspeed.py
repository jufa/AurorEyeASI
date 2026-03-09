#!/usr/bin/env python3
import sys
import gphoto2 as gp

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <shutterspeed>")
        print("Example: ./set_shutterspeed.py 1/125")
        sys.exit(1)

    shutterspeed_value = sys.argv[1]

    # Initialize camera
    camera = gp.Camera()
    camera.init()

    try:
        # Get config
        config = camera.get_config()
        # Find shutter speed setting
        shutterspeed = config.get_child_by_name('shutterspeed')

        # Set the value (as label)
        shutterspeed.set_value(shutterspeed_value)
        camera.set_config(config)

        print(f"Shutter speed set to {shutterspeed_value} successfully.")

    except gp.GPhoto2Error as e:
        print(f"Error setting shutter speed: {e}")

    finally:
        camera.exit()

if __name__ == "__main__":
    main()
