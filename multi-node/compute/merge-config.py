#!/usr/bin/python

import os
import shutil
import argparse
import ConfigParser

parser = argparse.ArgumentParser(description="Config file merge tool")
parser.add_argument('file1', nargs='?', default='')
parser.add_argument('file2', nargs='?', default='')
args = parser.parse_args()

config1 = ConfigParser.SafeConfigParser()
config2 = ConfigParser.SafeConfigParser()

if not os.path.exists(args.file1 + '.orig'):
    shutil.copy(args.file1, args.file1 + '.orig')

config1.readfp(open(args.file1))
config2.readfp(open(args.file2))

defaults = config2.defaults()
for key in defaults:
    config1.set('DEFAULT', key, defaults[key])

for section in config2.sections():
    if not config1.has_section(section):
        config1.add_section(section)

    for key, value in config2.items(section):
        config1.set(section, key, value)

with open(args.file1 + '.out', 'wb') as outfile:
    config1.write(outfile)
