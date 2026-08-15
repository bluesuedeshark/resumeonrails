# Resume on Rails

A résumé modeled as a Rails app instead of a document — career data as real ActiveRecord records
(`Role`, `Accomplishment`, `Skill`), not a PDF.

## What's here

- **Headline** (`/`) — the pitch: intro, a handful of curated highlights, skills grouped into a
  few clickable categories.
- **Timeline** (`/timeline`) — the full chronological record.
- **Carline** (`/carline`) — a data-driven look at school pickup-line optimization: raw data, a
  second dataset joined in to find a pattern the first one alone couldn't show, and an interactive
  dashboard for weighing trade-offs between fixes. Also has a small tap-to-jump game
  (`/carline/play`), because it should be.

## Stack

Ruby on Rails 8.1, SQLite, Tailwind CSS v4, Hotwire (Turbo + Stimulus). No JS framework.

## Running it locally

```
bundle install
bin/rails db:seed
bin/rails server
```

## Why this exists

Built in a weekend as a follow-up to an unexpectedly fun conversation at a conference — a way to
show, not just tell.
