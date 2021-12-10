import sys
import re

pattern = re.compile(r'(?:begin{document})([\s\S]*)(?:\\end{document})')

with open(str(sys.argv[1]), 'r+') as f:
    lines = f.readlines()
    s = "".join(lines)
    with open(str(sys.argv[1]), 'w') as g:
        g.writelines(pattern.findall(s))