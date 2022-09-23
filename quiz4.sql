with event_speakers_details as(
  select
    events.event_no,
    events.event_name,
    events.held_on,
    speakers.order_of_speech,
    speakers.speaker_name,
    speakers.speech_title
  from
    events
  inner join
    speakers
  on
    events.event_no=speakers.event_no
),
event_attendees_details as(
  select
    events.event_no,
    events.event_name,
    events.held_on,
    attendees.order_of_application,
    attendees.account_name
  from
    events
  inner join
    attendees
  on
    events.event_no=attendees.event_no
)
, union_detail as(
  select
    event_no,
    event_name,
    held_on,
    order_of_speech,
    speaker_name,
    speech_title,
    null as order_of_application,
    null as account_name
  from
    event_speakers_details
  union
  select
    event_no,
    event_name,
    held_on,
    null as order_of_speech,
    null as speaker_name,
    null as speech_title,
    order_of_application,
    account_name
  from
    event_attendees_details
)
select
  events.event_no,
  events.event_name,
  events.held_on,
  case when union_detail.order_of_speech is null then '' else cast(union_detail.order_of_speech as varchar(50)) end as order_of_speech,
  case when union_detail.speaker_name is null then '' else union_detail.speaker_name end as speaker_name,
  case when union_detail.speech_title is null then '' else union_detail.speech_title end as speech_title,
  case when union_detail.order_of_application is null then '' else cast(union_detail.order_of_application as varchar(50)) end as order_of_application,
  case when union_detail.account_name is null then '' else union_detail.account_name end as account_name
from
  events
left join
  union_detail
on
  events.event_no=union_detail.event_no
order by
  event_no,
  case
    when order_of_speech is null then 1
    else 0
  end,
  order_of_speech,
  case
    when order_of_application is null then 1
    else 0
  end,
  order_of_application;