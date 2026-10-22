# DIFF Radio posting app

Static page on GitHub Pages. Talks to Supabase through narrow SECURITY DEFINER RPCs
(`posting_clips`, `posting_set_duration`, `posting_set_retired`) gated on an access code.

No editorial data lives in this repo — clips, schedules and numbers all come from the
database at runtime. The publishable key below is designed to be public; it reaches
nothing without the code.

Source of truth for clips: Dropbox `HOC/<date> <Artist>/`.
