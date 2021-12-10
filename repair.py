import sys
import re
import json

pattern = re.compile(r'(?:begin{document})([\s\S]*)(?:\\end{document})')

j = open('../../replace.json')
json_data = json.load(j)

with open(str(sys.argv[1]), 'r+') as f:
    lines = f.readlines()
    s = "".join(lines)

    for i in json_data["regex"]:
        s = re.sub(i["search"], i["replace"], s)

    with open(str(sys.argv[1]), 'w') as g:
        g.writelines(pattern.findall(s))