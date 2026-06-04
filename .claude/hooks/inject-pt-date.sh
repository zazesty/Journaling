#!/bin/bash
# Surface today's PT date at session start. Belt-and-suspenders after the one
# historical date skip (06-01a, when a writer used the UTC currentDate and filed
# a page under a day that hadn't happened locally). The writer still runs
# `TZ=America/Los_Angeles date` themselves before filing — this hook just makes
# the right date hard to miss.
echo "Today in Pacific Time: $(TZ=America/Los_Angeles date)"
exit 0
