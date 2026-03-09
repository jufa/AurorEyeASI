#!/usr/bin/env python3
import gphoto2 as gp
import time
import argparse
import signal
from datetime import datetime


class GPhoto2IntervalCapture:
    def __init__(self, interval_seconds: float):
        self.interval = interval_seconds
        self.running = True
        signal.signal(signal.SIGINT, self._handle_exit)
        signal.signal(signal.SIGTERM, self._handle_exit)

        print(f"[INFO] Initializing gphoto2 library...")
        self.context = gp.Context()
        self.camera = self._connect_camera()
        self.flush_event_queue(self.camera, self.context)

    def _handle_exit(self, signum, frame):
        print("\n[INFO] Stopping capture loop...")
        self.running = False

    def _connect_camera(self):
        """Connect to the first detected camera."""
        cameras = gp.Camera.autodetect()
        if not cameras:
            raise RuntimeError("No camera detected. Connect a camera and try again.")

        name, addr = cameras[0]
        print(f"[INFO] Using camera: {name} @ {addr}")

        camera = gp.Camera()
        camera.init()
        return camera

    def flush_event_queue(self, camera, context):
        """
        Drain all pending events from the camera event queue.
        """
        print("[INFO] Flushing camera event queue...")
        try:
            while True:
                event_type, data = camera.wait_for_event(100, context)  # 100 ms timeout
                if event_type == gp.GP_EVENT_TIMEOUT:
                    break  # no more events
                # Optionally, print or log discarded events:
                # print(f"[DEBUG] Discarded event: {event_type}")
        except gp.GPhoto2Error as e:
            print(f"[WARN] Error while flushing events: {e}")
        print("[INFO] Event queue flushed.")

    def _capture_image(self):
        """Trigger a single capture and download it."""
        timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        filename = f"capture_{timestamp}.jpg"

        print(f"[{timestamp}] Capturing image... ", end="", flush=True)
        try:
            file_path = self.camera.capture(gp.GP_CAPTURE_IMAGE)
            target = filename
            camera_file = self.camera.file_get(
                file_path.folder, file_path.name, gp.GP_FILE_TYPE_NORMAL
            )
            camera_file.save(target)
            print(f"done → {target}")
        except gp.GPhoto2Error as e:
            print(f"failed: {e}")

    def start(self):
        """Run capture loop until interrupted."""
        print(f"[INFO] Starting capture every {self.interval:.1f} s. Press Ctrl+C to stop.")
        while self.running:
            start_time = time.time()
            self._capture_image()
            elapsed = time.time() - start_time
            time.sleep(max(0, self.interval - elapsed))

        print("[INFO] Capture loop ended.")
        self.camera.exit()


def main():
    parser = argparse.ArgumentParser(description="Periodic still image capture using python-gphoto2.")
    parser.add_argument("interval", type=float, help="Interval between captures in seconds (e.g., 5.0)")
    args = parser.parse_args()

    capturer = GPhoto2IntervalCapture(args.interval)
    capturer.start()


if __name__ == "__main__":
    main()
