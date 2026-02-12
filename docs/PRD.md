# campaign manager - product requirements

## overview

a dnd campaign platform that connects dungeon masters with players through smart matching.

## core flows

### auth flow
- sign up (google/discord/email)
- capture full name
- onboarding wizard
- redirect to dashboard

### dashboard
- main hub
- create campaign
- browse campaigns
- view invitations
- edit profile

### campaign flow
- create campaign
- set schedule
- define player slots
- accept/reject applications
- manage campaign state

## database

### users
- id, full_name, display_name
- roles[] (player, dm, supporter)
- availability_json (weekly schedule)
- experience_level (0, 1-3, 4-20, 20+)
- preferences[] (atmosphere, play style, voice/text, etc)
- onboarding_complete
- in_matching_pool

### campaigns
- id, dm_id, name, description
- schedule_json
- atmosphere (fantasy, horror, silly)
- required_experience
- accepting_players (bool)
- status (forming, active, paused, completed)

### applications
- id, user_id, campaign_id
- status (pending, accepted, rejected)

## matching algorithm (mvp)

factors:
- role compatibility
- schedule overlap
- atmosphere preference
- experience level match

score 0-100, threshold 70 = recommendation

## ux principles

- simple, transparent
- no complex messaging (mvp)
- structured invites
- clear status indicators
