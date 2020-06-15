import re
import fileinput

if __name__ == "__main__":
    # Drop the first line
    fileinput.input()

    print(",".join(("SERVICE", "CONTAINER_NAME", "NAMESPACE", "SIZE")))

    for line in fileinput.input():
        match = re.match(r"^\w{12}\s*k8s_([^_]+)_([^_]+)_([^_]+)(?:\S*\s*){2}([\w\.]*)", line)

        if match:
            print(",".join(match.groups()))
