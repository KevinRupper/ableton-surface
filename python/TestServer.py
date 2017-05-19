import sys
import time

from Network import Network

try:
    server = Network()
    server.start()

    while 1:
        time.sleep(1)

except KeyboardInterrupt:
    print >> sys.stderr, '\nExiting.\n'
    sys.exit(0)