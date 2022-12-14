import sys
import regex as re
import json

pattern = re.compile(r'(?:begin\{document\})([\s\S]*)(?:\\end\{document\})')

j = open('../../replace.json')
json_data = json.load(j)

with open(str(sys.argv[1]), 'r+') as f:
    filename = f.name.split('/')[-1]
    lines = f.readlines()
    content = "".join(lines)

    for i in json_data["regex"]:
        if "disabled" in i and i["disabled"]:
            continue

        if i["filename"] and not re.compile(i["filename"]).match(filename):
            continue
        if "recursive" in i and i["recursive"]:
            pattern = re.compile(i["search"])
            match = pattern.search(content)
            while match is not None:
                content = re.sub(i["search"], i["replace"], content)
                match = pattern.search(content)
        else:
            content = re.sub(i["search"], i["replace"], content)

    for i in json_data["lower"]:
        if i["filename"] and not re.compile(i["filename"]).match(filename):
            continue            
        content = re.sub(i["search"], lambda m: m.group(0).lower(), content)

    with open(str(sys.argv[1]), 'w') as g:
        if (filename.endswith(".tex")):
            g.writelines(pattern.findall(content))
        else:
            g.write(content)
            

    