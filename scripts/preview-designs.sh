#!/usr/bin/env bash
# Preview the 5 redesign prototypes (branch: redesign/three-sections).
#
#   ./scripts/preview-designs.sh          # serve ALL five on ports 1314-1318
#   ./scripts/preview-designs.sh rd3      # serve one design on port 1313
#   ./scripts/preview-designs.sh stop     # kill all preview servers
#
# Designs:
#   rd1-sketchbook  hand-drawn magazine (evolution of current identity)
#   rd2-monograph   literary print, essay-first
#   rd3-darkroom    photo-first immersive dark
#   rd4-triptych    three color-coded doors
#   rd5-index       research-lab database (rywalker-esque)

set -euo pipefail
cd "$(dirname "$0")/.."

THEMES=(rd1-sketchbook rd2-monograph rd3-darkroom rd4-triptych rd5-index)
BASE_PORT=1314
PIDFILE=/tmp/guisho-design-previews.pids

stop_all() {
  if [[ -f "$PIDFILE" ]]; then
    xargs -r kill < "$PIDFILE" 2>/dev/null || true
    rm -f "$PIDFILE"
    echo "Stopped all preview servers."
  else
    pkill -f "hugo server.*--theme rd" 2>/dev/null && echo "Stopped." || echo "Nothing running."
  fi
}

case "${1:-all}" in
  stop)
    stop_all
    ;;
  all)
    stop_all 2>/dev/null || true
    : > "$PIDFILE"
    i=0
    for t in "${THEMES[@]}"; do
      port=$((BASE_PORT + i))
      hugo server --theme "$t" --port "$port" --buildDrafts=false \
        --disableFastRender --renderToMemory --noHTTPCache \
        >/tmp/guisho-preview-"$t".log 2>&1 &
      echo $! >> "$PIDFILE"
      echo "  $t  →  http://localhost:$port/"
      i=$((i + 1))
    done
    echo
    echo "All five serving. Logs: /tmp/guisho-preview-<theme>.log"
    echo "Stop with: ./scripts/preview-designs.sh stop"
    ;;
  *)
    # single design: match prefix (rd1 → rd1-sketchbook)
    match=""
    for t in "${THEMES[@]}"; do
      [[ "$t" == "$1"* ]] && match="$t" && break
    done
    [[ -z "$match" ]] && { echo "Unknown design: $1 (use rd1..rd5, all, or stop)"; exit 1; }
    echo "Serving $match at http://localhost:1313/ (Ctrl-C to stop)"
    exec hugo server --theme "$match" --port 1313 --renderToMemory
    ;;
esac
