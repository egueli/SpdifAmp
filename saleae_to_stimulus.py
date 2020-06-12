#!/usr/bin/env/python3

import sys

last_time = 0
for line in sys.stdin:
    string_fields = line.split("\t")
    time_string = string_fields[0]
    value_string = string_fields[1]
    time_ns = int(float(time_string) * 1e9)
    delta = time_ns - last_time
    value = int(value_string)
    print(f"{delta} ns {value}")
    last_time = time_ns
