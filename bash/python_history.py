#!/usr/bin/python3
import os, readline, atexit

python_history = os.path.join(os.environ['HOME'], '.python_history')
try:
  readline.read_history_file(python_history)
  readline.parse_and_bind('tab: complete')
  readline.set_history_length(5000)
  atexit.register(readline.write_history_file, python_history)
except IOError:
  print('Failed to initialize python history')

  del os, readline, atexit

from pprint import pprint
