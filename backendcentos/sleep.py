#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import signal
import sys
import time


def signal_term_handler(signal=None, frame=None, name='SIGTERM'):
    print("got {}".format(name))
    sys.exit(0)


signal.signal(signal.SIGTERM, signal_term_handler)

# infinity = int(float("inf"))  # does not work
low_infinity = sys.maxsize / 10000000000

try:
    print("python sleeping")
    time.sleep(low_infinity)
except KeyboardInterrupt:
    signal_term_handler(name='keyboard interrupt')
