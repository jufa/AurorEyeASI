#!/usr/bin/env python

# python-gphoto2 - Python interface to libgphoto2
# http://github.com/jim-easterbrook/python-gphoto2
# Copyright (C) 2018-22  Jim Easterbrook  jim@jim-easterbrook.me.uk
#
# This file is part of python-gphoto2.
#
# python-gphoto2 is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# python-gphoto2 is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with python-gphoto2.  If not, see
# <https://www.gnu.org/licenses/>.

"""Simple time lapse script.

This works OK with my Canon SLR, but will probably need changes to work
with another camera.

"""

from contextlib import contextmanager
import locale
import os
import subprocess
import sys
import time
from datetime import datetime

import gphoto2 as gp


# time between captures
INTERVAL = 1
# temporary directory
WORK_DIR = '/mnt/extstore/zve10'
# result
OUT_FILE = 'time_lapse.mp4'
# file name template
TEMPLATE = 'UNIT11_ZVE10_%Y-%m-%dT%H-%M-%S.%f'

D229_OPTS = [
  19660810,
  16384010,
  13107210,
  9830410,
  8519690,
  6553610,
  5242890,
  932170,
  276810,
  621450,
  2097162,
  1638410,
  1310730,
  1048586,
  851978,
  655370,
  524298,
  393226,
  327690,
  262154,
  65539,
  65540,
  65541,
  65542,
  65544,
  65546,
  65549,
  65551,
  65556,
  65561,
  65566,
  65576,
  65586,
  65596,
  65616,
  65636,
  65661,
  65696,
  65736,
  65786,
  65856,
  65936,
  66036,
  66176,
  66336,
  66536,
  66786,
  67136,
  67536,
  68036,
  68736,
  69536
]

SHUTTERSPEEDS=[
  "300/10",
  "250/10",
  "200/10",
  "150/10",
  "130/10",
  "10/1",
  "80/10",
  "60/10",
  "50/10",
  "40/10",
  "32/10",
  "25/10",
  "20/10",
  "16/10",
  "13/10",
  "10/10",
  "8/10",
  "6/10",
  "5/10",
  "4/10",
  "1/3",
  "1/4",
  "1/5",
  "1/6",
  "1/8",
  "1/10",
  "1/13",
  "1/15",
  "1/20",
  "1/25",
  "1/30",
  "1/40",
  "1/50",
  "1/60",
  "1/80",
  "1/100",
  "1/125",
  "1/160",
  "1/200",
  "1/250",
  "1/320",
  "1/400",
  "1/500",
  "1/640",
  "1/800",
  "1/1000",
  "1/1250",
  "1/1600",
  "1/2000",
  "1/2500",
  "1/3200",
  "1/4000",
  "Bulb"
]

@contextmanager
def configured_camera():
    # initialise camera
    camera = gp.Camera()
    camera.init()
    # for v in D229_OPTS:++++
    s = "300/10"
    while True:
        s = input("enter shutterspeed string: ")
        cfg = camera.get_config()
        # shutter_cfg = cfg.get_child_by_name('d229')
        shutter_cfg = cfg.get_child_by_name('shutterspeed')
        shutter_cfg.set_value(s)
        camera.set_config(cfg)
        shutterspeed = shutter_cfg.get_value()
        print(f"set attempt to {s}, result: {shutterspeed}")

        # use camera
        # yield camera
        


def empty_event_queue(camera):
    while True:
        type_, data = camera.wait_for_event(10)
        if type_ == gp.GP_EVENT_TIMEOUT:
            return
        if type_ == gp.GP_EVENT_FILE_ADDED:
            # get a second image if camera is set to raw + jpeg
            print('Unexpected new file', data.folder + data.name)


def main():
    locale.setlocale(locale.LC_ALL, '')
    if not os.path.exists(WORK_DIR):
        os.makedirs(WORK_DIR)
    template = os.path.join(WORK_DIR, TEMPLATE)
    next_shot = time.time() + 1.0
    count = 0
    with configured_camera() as camera:
        while False:
            try:
                empty_event_queue(camera)
                while True:
                    sleep = next_shot - time.time()
                    if sleep < 0.0:
                        break
                    time.sleep(sleep)
                path = camera.capture(gp.GP_CAPTURE_IMAGE)
                print('capture', path.folder + path.name)
                camera_file = camera.file_get(
                    path.folder, path.name, gp.GP_FILE_TYPE_NORMAL)
                now = datetime.now()
                # Format the datetime as a string
                filename = now.strftime(TEMPLATE)[:-3]
                filename = os.path.join(WORK_DIR, filename)
                filename = f"{filename}_{count:08d}.jpg"
                print(f"saving as {filename}")
                camera_file.save(filename)
                camera.file_delete(path.folder, path.name)
                next_shot += INTERVAL
                count += 1
            except KeyboardInterrupt:
                break
    # subprocess.check_call(['ffmpeg', '-r', '25',
    #                        '-i', template, '-c:v', 'h264', OUT_FILE])
    # for i in range(count):
    #     os.unlink(template % i)
    # return 0


if __name__ == "__main__":
    sys.exit(main())