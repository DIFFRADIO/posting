# DIFF Radio — Posting

Static page, hosted on GitHub Pages at https://diffradio.github.io/posting/

Reads and writes Supabase schema `insights` through `SECURITY DEFINER` RPCs in
`public`. The tables themselves have RLS on with zero policies, so nothing is
reachable except through those functions, and no function returns anything
without a valid access code.

## Tabs

**Schedule** — the week board. One card per post: time, platform, clip, title,
caption, copy buttons, and the status tick. Ticking **queued** is the record —
there is no second step. "+ Standard day" lays out YouTube 09:00, Instagram
12:00, YouTube 17:00, TikTok 18:00 and TikTok 20:00; change the times on the
cards if the day is different.

**Clip bank** — every clip in Dropbox, by artist and source. Filter by artist,
source, length band, or "never posted". Durations are typed here until the
`NNs` filename suffix lands, then they parse automatically.

**Numbers** — what's on the board so far, plus the findings counted by hand
before this app existed. No platform API is wired in yet.

## RPCs

| Function | Does |
|---|---|
| `posting_bank(code)` | every clip, with a posted-count |
| `posting_posts(code, from, to)` | posts in a date window |
| `posting_save_post(code, id, jsonb)` | insert or update a post; a chosen clip fills artist, source, path and duration |
| `posting_set_post_status(code, id, status)` | planned / queued / held / skipped / failed |
| `posting_set_duration(code, clip, seconds)` | clip length |
| `posting_set_retired(code, clip, bool)` | take a clip out of the pool |

There is no delete. A slot you don't want goes to **skipped** and stays in the
record.

## Deploying

Edit `index.html`, commit, push. GitHub Pages serves it within a minute or so.
`.nojekyll` stops Pages trying to build it.
