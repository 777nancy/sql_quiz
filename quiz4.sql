WITH
  event_speakers_details AS (
    SELECT
      events.event_no,
      events.event_name,
      events.held_on,
      speakers.order_of_speech,
      speakers.speaker_name,
      speakers.speech_title
    FROM
      events
      INNER JOIN speakers ON events.event_no = speakers.event_no
  ),
  event_attendees_details AS (
    SELECT
      events.event_no,
      events.event_name,
      events.held_on,
      attendees.order_of_application,
      attendees.account_name
    FROM
      events
      INNER JOIN attendees ON events.event_no = attendees.event_no
  ),
  union_detail AS (
    SELECT
      event_no,
      event_name,
      held_on,
      order_of_speech,
      speaker_name,
      speech_title,
      NULL AS order_of_application,
      NULL AS account_name
    FROM
      event_speakers_details
    UNION
    SELECT
      event_no,
      event_name,
      held_on,
      NULL AS order_of_speech,
      NULL AS speaker_name,
      NULL AS speech_title,
      order_of_application,
      account_name
    FROM
      event_attendees_details
  )
SELECT
  events.event_no,
  events.event_name,
  events.held_on,
  CASE
    WHEN union_detail.order_of_speech IS NULL THEN ''
    ELSE CAST(union_detail.order_of_speech AS VARCHAR(50))
  END AS order_of_speech,
  CASE
    WHEN union_detail.speaker_name IS NULL THEN ''
    ELSE union_detail.speaker_name
  END AS speaker_name,
  CASE
    WHEN union_detail.speech_title IS NULL THEN ''
    ELSE union_detail.speech_title
  END AS speech_title,
  CASE
    WHEN union_detail.order_of_application IS NULL THEN ''
    ELSE CAST(union_detail.order_of_application AS VARCHAR(50))
  END AS order_of_application,
  CASE
    WHEN union_detail.account_name IS NULL THEN ''
    ELSE union_detail.account_name
  END AS account_name
FROM
  events
  LEFT JOIN union_detail ON events.event_no = union_detail.event_no
ORDER BY
  event_no,
  CASE
    WHEN order_of_speech IS NULL THEN 1
    ELSE 0
  END,
  order_of_speech,
  CASE
    WHEN order_of_application IS NULL THEN 1
    ELSE 0
  END,
  order_of_application
;