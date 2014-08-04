#!/python
import sys
import os

for filename in os.listdir('/dev/in'):
    with open(os.path.join('/dev/in', filename), 'r') as f:
        f.read()

sys.stdout.write('Ok')
