import sys
import re
import base64

def convert_to_base64(file_path):
    with open(file_path, "rb") as f:
        return base64.b64encode(f.read()).decode()

work_space = sys.argv[1]
values_map = dict()
with open(f"{work_space}/env.conf", "r") as f:
    for line in f.readlines():
        match = re.match("^(.*)=(.*)$", line.strip())
        if match:
            values_map[match.group(1)] = match.group(2)

values_map["KEY"] = convert_to_base64(f"{work_space}/tls.key")
values_map["CERT"] = convert_to_base64(f"{work_space}/tls.cert")

with open(f"{work_space}/tls-secret.yaml", "r+") as f:
    content = f.read()
    f.truncate(0)
    f.seek(0)
    f.write(content.format(**values_map))

print("完成 tls-secret.yaml 的生成")