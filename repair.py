import sys
import re
import json

pattern = re.compile(r'(?:begin{document})([\s\S]*)(?:\\end{document})')

j = open('../../replace.json')
json_data = json.load(j)

with open(str(sys.argv[2]), 'r+') as f:
    lines = f.readlines()
    s = "".join(lines)

    if (sys.argv[1] == '-latex'):
        for i in json_data["latex_regex"]:
            s = re.sub(i["search"], i["replace"], s)

        with open(str(sys.argv[2]), 'w') as g:
            g.writelines(pattern.findall(s))
    else:
        for i in json_data["md_lower"]:
            s = re.sub(i, lambda m: m.group(0).lower(), s)
        for i in json_data["md_regex"]:
            s = re.sub(i["search"], i["replace"], s)
        with open(str(sys.argv[2]), 'w') as g:
            g.write(s)

    