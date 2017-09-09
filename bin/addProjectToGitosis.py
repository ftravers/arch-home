f = open("../resources/htmlInputTestStrings.properties", 'r')
for line in f:
    parts = string.split(line, '=')
    print parts
