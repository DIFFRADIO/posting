-- DIFF Radio · posting app
-- Run this once in the Supabase SQL editor (DR Source of Truth).
-- Step 1 installs the delete function the app calls.
-- Step 2 clears the 42 dead Frey slots left by the mis-fired phase template.

-- ---------------------------------------------------------------
-- 1. the delete function
-- ---------------------------------------------------------------
create or replace function public.posting_delete_post(p_code text, p_id uuid)
 returns boolean
 language plpgsql
 security definer
 set search_path to ''
as $function$
declare v_url text;
begin
  if not insights.caller_ok(p_code) then
    return false;
  end if;

  -- a slot that has already gone live is never deletable
  select url into v_url from insights.posts where id = p_id;
  if v_url is not null and v_url <> '' then
    return false;
  end if;

  delete from insights.posts where id = p_id;
  return found;
end $function$;

revoke execute on function public.posting_delete_post(text, uuid) from public;
grant  execute on function public.posting_delete_post(text, uuid) to anon, authenticated;

-- ---------------------------------------------------------------
-- 2. one-off cleanup: the duplicate Frey slots
-- ---------------------------------------------------------------
delete from insights.posts
where artist_name ilike 'frey'
  and status = 'skipped'
  and scheduled_for::date >= '2026-10-28';

-- ---------------------------------------------------------------
-- 3. check: should return 13 rows, Wed 28 -> Sat 31
-- ---------------------------------------------------------------
select scheduled_for::date as day,
       to_char(scheduled_for,'HH24:MI') as at,
       platform, status
from insights.posts
where artist_name ilike 'frey' and scheduled_for::date >= '2026-10-28'
order by scheduled_for, platform;
