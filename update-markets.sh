#!/bin/bash
# Polymarket Tracker - Market Update Script
# Runs every 12 hours to fetch new stock-market relevant markets

set -e

REPO_DIR="/root/clawd/polymarket-tracker"
cd "$REPO_DIR"

echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] Starting market update..."

# Fetch active markets and filter for stock-market relevant ones
# Excludes sports (NBA, NFL, NHL, FIFA, UFC, etc.)
curl -s "https://gamma-api.polymarket.com/markets?limit=500&active=true&closed=false" | jq '
  [.[] | select(
    .closed == false and 
    .active == true and 
    .volumeNum > 100000 and
    # Must match stock-relevant keywords
    (.question | test("tariff|ceasefire|invasion|invade|attack|strike|nuclear|sanction|embargo|recession|inflation|fed rate|rate cut|treasury|deficit|debt|powell|nato|military|troops|war[^r]|bombing|missile|putin|zelenskyy|xi jinping"; "i")) and
    # Exclude sports
    (.question | test("nba|nfl|nhl|mlb|fifa|ufc|world cup|stanley cup|mvp|rookie|championship|playoffs|finals|super bowl|olympics"; "i") | not) and
    # Exclude entertainment/random
    (.question | test("gta|album|movie|grammy|oscar|emmy|bitcoin|crypto|eth|btc|doge"; "i") | not)
  )] | 
  sort_by(-.volumeNum) |
  .[0:20] |
  map({
    slug: .slug,
    category: (
      if (.question | test("russia|ukraine|ceasefire|putin|zelenskyy"; "i")) then "geopolitical"
      elif (.question | test("china|taiwan|invade|invasion|xi"; "i")) then "geopolitical"
      elif (.question | test("iran|israel|attack|strike|military|missile|nato|bombing|nuclear|troops"; "i")) then "geopolitical"
      elif (.question | test("tariff|trade|sanction|embargo"; "i")) then "trade"
      elif (.question | test("fed|rate|inflation|recession|gdp|unemployment|economy|treasury|deficit|debt|powell"; "i")) then "economic"
      else "political"
      end
    )
  })
' > markets.json.tmp

# Check if we got valid data
MARKET_COUNT=$(jq 'length' markets.json.tmp 2>/dev/null || echo "0")
if [ "$MARKET_COUNT" -lt 1 ]; then
    echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] No markets found or API error. Keeping existing markets."
    rm -f markets.json.tmp
    exit 0
fi

echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] Found $MARKET_COUNT relevant markets."

mv markets.json.tmp markets.json

# Check if there are changes
if git diff --quiet markets.json 2>/dev/null; then
    echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] No changes to markets."
    exit 0
fi

# Commit and push
git add markets.json
git commit -m "Auto-update markets $(date -u '+%Y-%m-%d %H:%M UTC')"
git push origin main

echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] Markets updated and pushed to GitHub."
