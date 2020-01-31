#!/bin/bash

if [[ $# < 2 || "$1" == '-h' || "$1" == '--help' ]]; then
        echo "Usage: $0 [-h|--help] host port [espeak args...]"
        exit 0
fi

host="$1"
port="$2"
shift 2
eargs="$@"
(python3 - $host $port <<EOF
from socketserver import BaseRequestHandler, UDPServer
from sys import argv

class PrintHandler(BaseRequestHandler):
    def handle(self):
        data = self.request[0].strip().decode('utf-8')
        print(data, flush=True)

host, port = argv[1], int(argv[2])
with UDPServer((host, port), PrintHandler) as svr:
    svr.serve_forever()
EOF
)       | grep --line-buffered --color=never -a '^<7> \[SLIC\] CID to deliver:' \
        | stdbuf -oL cut -d' ' -f6- \
        | sed -u s/+1//g \
        | sed -u 's/1\([0-9]\{10\}\)/\1/g' \
        | sed -u -e ':loop' -e 's/\([0-9]\)\([0-9]\)/\1 \2/g' -e 't loop' \
        | while read caller; do \
                espeak $eargs "Call from $caller" --stdout | aplay 2>/dev/null; done
exit 0
