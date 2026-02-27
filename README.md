# Polymarket Tracker

A real-time tracker for Polymarket prediction markets that are relevant to stock market movements.

![Screenshot](screenshot.png)

## Features

- **Curated Markets**: Only shows markets that could impact stocks (geopolitical events, trade policy, economic indicators)
- **Real-time Data**: Fetches live data from Polymarket's API
- **Side Panel Details**: Click any market to see resolution details and order book
- **Auto-refresh**: Updates every 60 seconds
- **Dark Theme**: Terminal-style aesthetic matching the entity tracker

## Tracked Categories

- **Geopolitical**: Russia-Ukraine ceasefire, China-Taiwan tensions
- **Political**: Putin/Zelenskyy leadership changes
- **Trade & Tariffs**: US tariff revenue, trade policy markets
- **Economic**: Inflation, Fed decisions, recession indicators

## Usage

Simply open `index.html` in a browser. No server required - all data is fetched client-side from Polymarket's public API.

### Hosting Options

1. **Local**: Open `index.html` directly
2. **GitHub Pages**: Enable Pages in repo settings
3. **Any static host**: Netlify, Vercel, etc.

## Tech Stack

- Vanilla HTML/CSS/JS
- Polymarket Gamma API
- JetBrains Mono + Inter fonts

## Color Scheme

Dark green terminal aesthetic:
- Background: `#0a0f0a`
- Accent: `#4a7c4a`
- Positive: `#5cb85c`
- Negative: `#c9302c`
- Warning: `#f0ad4e`

## License

MIT
