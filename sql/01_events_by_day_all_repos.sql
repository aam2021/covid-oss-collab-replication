-- 01_events_by_day_all_repos.sql
--
-- Purpose:
--   Aggregate daily counts of 14 GitHub event types from GH Archive
--   for:
--     - Pre-COVID: 2017-01-01 to 2019-12-31
--     - Post-COVID: 2023-01-01 to 2025-10-27
--
-- Output columns:
--   event_date   (DATE)
--   year         (INTEGER)
--   type         (STRING)      -- GitHub event type
--   total_events (INTEGER)     -- daily count of that event type
--
-- Dataset: githubarchive.day

WITH daily_counts AS (
  -- Post-COVID (2023–2025)
  SELECT
    COUNT(*) AS cnt,
    type,
    2025 AS year,
    _TABLE_SUFFIX AS suffix
  FROM `githubarchive.day.2025*`
  -- align with study window (up to 2025-10-27)
  WHERE _TABLE_SUFFIX <= '1027'
  GROUP BY type, _TABLE_SUFFIX

  UNION ALL

  SELECT
    COUNT(*) AS cnt,
    type,
    2024 AS year,
    _TABLE_SUFFIX AS suffix
  FROM `githubarchive.day.2024*`
  GROUP BY type, _TABLE_SUFFIX

  UNION ALL

  SELECT
    COUNT(*) AS cnt,
    type,
    2023 AS year,
    _TABLE_SUFFIX AS suffix
  FROM `githubarchive.day.2023*`
  GROUP BY type, _TABLE_SUFFIX

  -- Pre-COVID (2017–2019)
  UNION ALL

  SELECT
    COUNT(*) AS cnt,
    type,
    2019 AS year,
    _TABLE_SUFFIX AS suffix
  FROM `githubarchive.day.2019*`
  GROUP BY type, _TABLE_SUFFIX

  UNION ALL

  SELECT
    COUNT(*) AS cnt,
    type,
    2018 AS year,
    _TABLE_SUFFIX AS suffix
  FROM `githubarchive.day.2018*`
  GROUP BY type, _TABLE_SUFFIX

  UNION ALL

  SELECT
    COUNT(*) AS cnt,
    type,
    2017 AS year,
    _TABLE_SUFFIX AS suffix
  FROM `githubarchive.day.2017*`
  GROUP BY type, _TABLE_SUFFIX
)

SELECT
  PARSE_DATE('%Y%m%d', CONCAT(CAST(year AS STRING), suffix)) AS event_date,
  year,
  type,
  SUM(cnt) AS total_events
FROM daily_counts
WHERE type IN (
  'CommitCommentEvent', 'CreateEvent', 'DeleteEvent',
  'GollumEvent', 'IssueCommentEvent', 'IssuesEvent',
  'MemberEvent', 'PublicEvent', 'PullRequestEvent',
  'PullRequestReviewEvent', 'PullRequestReviewCommentEvent',
  'PushEvent', 'ReleaseEvent', 'WatchEvent'
)
GROUP BY event_date, year, type
ORDER BY event_date, type;
