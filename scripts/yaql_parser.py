#!/usr/bin/python
# usage:
# yaql-parser.py --file test.yaml --expression "$.bake.destinations.len()
from __future__ import print_function

import getopt
import sys

import yaml
import yaql


def usage():
    print("usage: yaql-parser.py --file= --expression=")


def parse_yaql(file, exp, debug):
    if debug is 1:
        print(file + ":" + exp)
    data_source = yaml.load(open(file, 'r'))
    engine = yaql.factory.YaqlFactory().create()
    expression = engine(exp)
    print(expression.evaluate(data=data_source), end='')


def main(argv):
    file = ""
    expression = ""
    debug = 0
    try:
        opts, _ = getopt.getopt(
            argv, "hfe:d", ["help", "file=", "expression="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt == '-d':
            debug = 1
        elif opt in ("-f", "--file"):
            file = arg
        elif opt in ("-e", "--expression"):
            expression = arg

    parse_yaql(file, expression, debug)


if __name__ == "__main__":
    main(sys.argv[1:])
