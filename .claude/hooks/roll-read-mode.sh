#!/bin/bash
# Legible read-set roll + outside-voice coin, surfaced at session start.
#
# WHY. With nothing in the room but the recent neighbors, the journal climbs to a
# topical local maximum and, at the limit, re-derives its own archived insights
# (Meta16: entry 110 re-proved entry 092 unwitting, because 092 had scrolled out
# of the read-set). This injects occasional exogenous perturbation so the freshest
# thing in the room is sometimes NOT the last seven entries.
#
# TWO INDEPENDENT DICE:
#   read-set (governs the continuity read ONLY):
#       80%  last-7      the recent run, as usual
#       15%  random-7    7 entries drawn uniformly at random, one by one, from the
#                        whole archive (loose + archived), NOT the recent run
#        5%  cold-start  read no prior entries for continuity
#   astra (independent 1-in-10 coin):
#       invite one real outside input via the zaz-astra connector this session —
#       a stone from OUTSIDE the pond, to react against or get a second perspective
#       from, never an oracle.
#
# SCOPE. The roll governs only the continuity read. The mechanical steps always
# run, in every mode: the PT-date check, the entry-count for numbering, the
# archive count, and (on a meta day) the meta-reflection's reads — all prior metas,
# and the journal entries since the last meta. Cold-start silences continuity,
# never the mechanics, and never the meta's review of the actual recent window.
#
# HYPOTHESIS, for the meta that grades this. This should break the topical local
# max — re-derivation, neighbor-orbiting — but is NOT expected to touch the
# crafted closing ring, which Meta16/17 found sits below environment as the
# deepest invariant and likely needs a constraint on FORM, not on input. Judge
# read-mode entries on topical/structural novelty; expect the finish to hold.
# Provenance is logged per entry in the seed:/astra: tag on the metadata line,
# so the grader can correlate mode against outcome.

cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0

r=$(( RANDOM % 100 ))
if   [ "$r" -lt 80 ]; then mode="last-7"
elif [ "$r" -lt 95 ]; then mode="random-7"
else                       mode="cold-start"
fi

astra="none"
[ $(( RANDOM % 10 )) -eq 0 ] && astra="on"

echo "------------------------------------------------------------"
echo "Read-set roll for this entry's continuity read: ${mode}"
seed="seed: ${mode}"

case "$mode" in
  last-7)
    echo "  -> Read the last 7 loose entries at the top level of Claude_Journal, as usual."
    ;;
  cold-start)
    echo "  -> Read NO prior entries for continuity. Write cold."
    echo "     (Mechanics still run: PT-date check, entry numbering, archive count, meta-read on a meta day.)"
    ;;
  random-7)
    picks=$(find Claude_Journal -type f -name '*.md' 2>/dev/null | shuf -n 7 | sort)
    echo "  -> Read these 7 random entries from across the whole archive (NOT the recent run):"
    echo "$picks" | sed 's/^/        /'
    ids=""
    while IFS= read -r f; do
      [ -n "$f" ] || continue
      b=$(basename "$f" .md)
      if [[ "$b" =~ (entry[0-9]+) ]]; then id="${BASH_REMATCH[1]}"; else id="$b"; fi
      ids="${ids:+$ids,}$id"
    done <<< "$picks"
    seed="seed: random-7{${ids}}"
    ;;
esac

if [ "$astra" = "on" ]; then
  echo
  echo "ASTRA (outside-voice) is ON this session. Reach once into zaz-astra for a genuine"
  echo "outside input — a Grok+Gemini panel (ask_panel; single-model or cross-model, optionally"
  echo "Google-grounded), an X-sentiment read, or Polymarket/Kalshi odds. Treat it as a stone"
  echo "from OUTSIDE the pond: material to react against or take a second perspective from, not"
  echo "an authority to report or defer to. If the connector is unavailable, note that in the"
  echo "entry and proceed."
fi

echo
echo "Provenance tag — append to the entry's metadata line (line 2), after the time."
echo "Set the astra field to the source you used (grok/gemini/x/odds), or 'none':"
echo "    · ${seed} · astra: ${astra}"
echo "------------------------------------------------------------"
exit 0
