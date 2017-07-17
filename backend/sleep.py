#!/usr/bin/env python
# -*- coding: utf-8 -*-

import signal
import sys
import time
from utilities.logs import get_logger

log = get_logger(__name__)


def signal_term_handler(signal=None, frame=None, name='SIGTERM'):
    log.info(f"got {name}")
    sys.exit(0)


signal.signal(signal.SIGTERM, signal_term_handler)

# infinity = int(float("inf"))  # does not work
low_infinity = sys.maxsize / 10000000000

try:
    log.info("python sleeping")
    time.sleep(low_infinity)
except KeyboardInterrupt:
    signal_term_handler(name='keyboard interrupt')
