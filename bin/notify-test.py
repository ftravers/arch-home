#!/usr/bin/env python2

import pynotify as n
import sys

if __name__ == '__main__':
    n.init('My Application Name')
    notification = n.Notification("Summary", "This is some sample content")
    n.show()
    sys.exit(1)
