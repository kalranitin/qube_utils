#./yaql-parser.py --file test.yaml --expression "$.bake.destinations.len()"
#!/usr/bin/python
import yaql
import yaml
import getopt
import sys

def parseYAQL(file, exp):
    data_source = yaml.load(open(file, 'r'))
    engine = yaql.factory.YaqlFactory().create()
    expression = engine(exp)
    print file + ":" + exp
    print expression.evaluate(data=data_source)
    #print file + ":" + expression


def main(argv):
    file=""
    expression=""
    try:
        opts, args = getopt.getopt(argv, "hfe:d", ["help", "file=","expression="])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt == '-d':
            global _debug
            _debug = 1
        elif opt in ("-f", "--file"):
            file = arg
        elif opt in ("-e", "--expression"):
            expression=arg

    parseYAQL(file, expression)    

if __name__ == "__main__":
    main(sys.argv[1:])