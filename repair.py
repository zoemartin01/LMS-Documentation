import sys
import re
import json

pattern = re.compile(r'(?:begin{document})([\s\S]*)(?:\\end{document})')

j = open('../../replace.json')
json_data = json.load(j)

with open(str(sys.argv[1]), 'r+') as f:
    filename = f.name.split('/')[-1]
    lines = f.readlines()
    content = "".join(lines)

    for i in json_data["lower"]:
        if i["filename"] and not re.compile(i["filename"]).match(filename):
            continue            
        content = re.sub(i["search"], lambda m: m.group(0).lower(), content)
    for i in json_data["regex"]:
        if i["filename"] and not re.compile(i["filename"]).match(filename):
            continue
        content = re.sub(i["search"], i["replace"], content)

    with open(str(sys.argv[1]), 'w') as g:
        if (filename.endswith(".tex")):
            g.writelines(pattern.findall(content))
        else:
            g.write(content)
            

    