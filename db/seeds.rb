# Idempotent — safe to re-run with `bin/rails db:seed`.
# All content pulled from hq/projects/resume.md + Desktop/"resume things"
# (2022 resume, the 2026 rethink draft, and the intro paragraph drafted 2026-08-15).
# No personal phone/home email/street here on purpose — same PII rule as the hq résumé draft.

AccomplishmentSkill.destroy_all
Accomplishment.destroy_all
Skill.destroy_all
Role.destroy_all
Education.destroy_all
Profile.destroy_all

# ---------------------------------------------------------------------------
# Profile
# ---------------------------------------------------------------------------
# NOTE: intro below is lifted close to verbatim from her 2026-08-15 draft —
# it's a first pass she's actively reworking (may merge with the 2022 version).
# Swap this out for her final copy whenever it's ready; nothing else depends on
# the wording.
Profile.create!(
  name: "Kaleigh Unger",
  headline: "Senior Analyst — Data, Systems & Applied AI",
  tagline: "I turn messy data and slow processes into things people actually use.",
  intro: <<~TEXT.squish,
    Ten years of experience in data science and data analytics, creating and running
    custom modeling solutions across financial, health, retail, and senior-living
    clients. Over the past 18 months, that expanded into computer science, software
    development, and agentic AI — including co-building and launching a working
    portal (React, Node.js, Python, Snowflake, SQL) for client-led data exploration.
    I also help an agentic startup research agent behavior, build capability ladders
    for testing, and hone agent behavior in live systems. I like understanding and
    optimizing systems — that's the thread running through financial services,
    marketing analytics, and now software.
  TEXT
  github_url: "https://github.com/bluesuedeshark",
  location: "Greer, SC"
)

# ---------------------------------------------------------------------------
# Skills
# ---------------------------------------------------------------------------
skills = {}
[
  [ "SAS", "Analytics & Modeling" ],
  [ "VBA", "Analytics & Modeling" ],
  [ "R", "Analytics & Modeling" ],
  [ "Python", "Analytics & Modeling" ],
  [ "SQL", "Analytics & Modeling" ],
  [ "K-Means Segmentation", "Analytics & Modeling" ],
  [ "RFM Modeling", "Analytics & Modeling" ],
  [ "Campaign Optimization", "Analytics & Modeling" ],
  [ "Geospatial / Huff Modeling", "Analytics & Modeling" ],
  [ "Ruby on Rails", "AI & Dev" ],
  [ "LLM Agents & Tooling", "AI & Dev" ],
  [ "Git / GitHub", "AI & Dev" ],
  [ "Snowflake", "AI & Dev" ],
  [ "Vercel", "AI & Dev" ],
  [ "Supabase", "AI & Dev" ],
  [ "Linux", "AI & Dev" ],
  [ "Workflow Automation", "Systems & Process" ],
  [ "Training & Curriculum Design", "Systems & Process" ],
  [ "Process Reverse-Engineering", "Systems & Process" ],
  [ "FINRA Licensing (6, 63, 7)", "Licenses" ],
  [ "Insurance Licensing", "Licenses" ]
].each do |name, category|
  skills[name] = Skill.create!(name: name, category: category)
end

def tag(accomplishment, skills, *names)
  names.each { |n| accomplishment.skills << skills.fetch(n) }
end

# ---------------------------------------------------------------------------
# Roles + accomplishments, oldest first
# ---------------------------------------------------------------------------

ocean_lakes = Role.create!(
  kind: "origin",
  title: "Nature Center Attendant",
  organization: "Ocean Lakes Family Campground",
  location: "Myrtle Beach, SC",
  starts_on: Date.new(2006, 6, 1),
  ends_on: Date.new(2006, 8, 31),
  current: false,
  position: 1,
  summary: "First job. The only real requirement was keeping the nature center " \
           "running and the register covered — everything else was free time. " \
           "This is the earliest evidence of a pattern that hasn't stopped since: " \
           "given a small box, expand it."
)
[
  [ "Rebuilt the inventory ordering process so restocks actually matched what was selling.", [ "Workflow Automation" ] ],
  [ "Wrote a plain-language shark-teeth identification guide so beachgoers could ID their own fossil finds.", [ "Training & Curriculum Design" ] ],
  [ "Started running short wildlife trainings for visitors most afternoons.", [ "Training & Curriculum Design" ] ],
  [ "Began keeping short-term local wildlife on hand so visitors could see live animals, not just displays.", [] ]
].each_with_index do |(desc, skill_names), i|
  a = ocean_lakes.accomplishments.create!(description: desc, position: i + 1)
  tag(a, skills, *skill_names)
end

geico = Role.create!(
  kind: "role",
  title: "Billing → Customer Service → Retention Specialist",
  organization: "GEICO",
  starts_on: Date.new(2006, 11, 1),
  ends_on: Date.new(2008, 4, 30),
  current: false,
  position: 2,
  summary: "Promoted twice in under two years, landing on a small, specialized " \
           "team built to save the accounts everyone else had given up on."
)
[
  [ "Promoted from billing into full customer service, then onto a small specialized retention team handling the hardest save calls.", [] ],
  [ "Earned a property & casualty insurance license.", [ "Insurance Licensing" ] ],
  [ "Fixed a gap in NPS scoring so positive feedback stopped being miscounted as low scores when automated input misread a response.", [ "Process Reverse-Engineering" ] ]
].each_with_index do |(desc, skill_names), i|
  a = geico.accomplishments.create!(description: desc, position: i + 1)
  tag(a, skills, *skill_names)
end

nm_associate = Role.create!(
  kind: "role",
  title: "Associate Representative",
  organization: "Northwestern Mutual",
  starts_on: Date.new(2008, 5, 1),
  ends_on: Date.new(2011, 1, 1),
  current: false,
  position: 3,
  summary: "Hired with no degree and no industry experience — brought in purely " \
           "as a fast, detail-obsessed learner."
)
[
  [ "Broke the agency record for applications submitted with zero errors by a single representative.", "agency record, zero errors", [] ],
  [ "Earned a life & health insurance license, then FINRA Series 6, 63, and 7.", nil, [ "FINRA Licensing (6, 63, 7)", "Insurance Licensing" ] ],
  [ "Promoted from assistant to associate financial representative, with authority to walk clients through and sign contracts.", nil, [] ]
].each_with_index do |(desc, metric, skill_names), i|
  a = nm_associate.accomplishments.create!(description: desc, metric: metric, position: i + 1)
  tag(a, skills, *skill_names)
end

nm_director = Role.create!(
  kind: "role",
  title: "Director of District Reporting & Training",
  organization: "Northwestern Mutual",
  starts_on: Date.new(2011, 1, 1),
  ends_on: Date.new(2013, 1, 1),
  current: false,
  position: 4,
  summary: "Owned how the district measured and taught new-agent progress."
)
[
  [ "Rebuilt new-agent production tracking end to end and shipped macros/dashboards giving agents real-time visibility into daily, weekly, and monthly goals.", [ "VBA", "Workflow Automation" ] ],
  [ "Developed and maintained the new-hire curriculum.", [ "Training & Curriculum Design" ] ]
].each_with_index do |(desc, skill_names), i|
  a = nm_director.accomplishments.create!(description: desc, position: i + 1)
  tag(a, skills, *skill_names)
end

nm_planning = Role.create!(
  kind: "role",
  title: "Advanced / Personal & Business Planning Analyst",
  organization: "Northwestern Mutual",
  starts_on: Date.new(2013, 1, 1),
  ends_on: Date.new(2016, 9, 1),
  current: false,
  position: 5,
  summary: "The only person in the office who knew how to structure blended " \
           "whole-life products — which meant teaching the people she reported to."
)
[
  [ "Was the only person in the office who could structure blended whole-life products, so taught classes to senior advisors and ran product design for most agents in-office.", nil, [ "Training & Curriculum Design" ] ],
  [ "Built highly accurate Personal Financial Plans — Social Security projections, amortization schedules, and scenario modeling — for advisors' clients.", nil, [ "Campaign Optimization" ] ],
  [ "Was offered an agent's contract without a bachelor's degree — the only person in the office to be, where a degree was a baseline requirement.", "only person in office without a degree", [] ]
].each_with_index do |(desc, metric, skill_names), i|
  a = nm_planning.accomplishments.create!(description: desc, metric: metric, position: i + 1)
  tag(a, skills, *skill_names)
end

amp = Role.create!(
  kind: "role",
  title: "Senior Analyst",
  organization: "Analytic Marketing Partners (AMP)",
  starts_on: Date.new(2016, 9, 1),
  ends_on: nil,
  current: true,
  position: 6,
  summary: "Ten years (and counting) of SAS-based custom modeling for financial, " \
           "health, retail, and senior-living clients — the deepest, most provable " \
           "track record."
)
[
  [ "Rebuilt the core report shell: automated branding/white-labeling that had been done by hand, and added versioning, conditional logic, and exception-handling.", nil, [ "SAS", "VBA", "Workflow Automation" ] ],
  [ "Consolidated three separately-maintained versions of the same report — often out of sync with each other — into one data-driven shell.", nil, [ "SAS", "Workflow Automation" ] ],
  [ "Became the team's mapping expert: automated per-run maps in PDF output, drive-time measurement, and Huff-model competitor analysis.", nil, [ "Geospatial / Huff Modeling" ] ],
  [ "Built a custom k-means segmentation for a \"group within a group\" financial-product campaign.", "400%+ response rate vs. prior efforts", [ "K-Means Segmentation", "SAS" ] ],
  [ "Designed a standard-deviation-based RFM variable, replacing bucketed RFM, for a partner's card campaign.", "record-breaking engagement", [ "RFM Modeling" ] ],
  [ "Solved an auto-loan campaign with no exact-match variables using reverse-logic modeling on the microgrid variables that were available.", nil, [ "Campaign Optimization" ] ],
  [ "Learned R in a single day to execute and validate a client's own R scoring model against their internal testing.", "same-day turnaround", [ "R" ] ],
  [ "Pushed a client off straight-selects and hot-zips onto modeling; the resulting multi-territory win expanded into all franchises plus a full-year budget for the account.", nil, [ "Campaign Optimization" ] ],
  [ "Tunes variable weighting in production models - catching over- and under-weighted inputs before they skew results.", nil, [] ]
].each_with_index do |(desc, metric, skill_names), i|
  a = amp.accomplishments.create!(description: desc, metric: metric, position: i + 1)
  tag(a, skills, *skill_names)
end

indie = Role.create!(
  kind: "role",
  title: "Independent — AI / Product Development",
  organization: "bluesuedeshark LLC",
  starts_on: Date.new(2025, 1, 1),
  ends_on: nil,
  current: true,
  position: 7,
  summary: "Self-directed pivot into applied AI and software — learning in " \
           "public, shipping real things."
)
[
  [ "Advising a non-technical client on standing up a personal dashboard she owns and controls, while building a bespoke, model-agnostic dashboard proof of concept.", nil, [ "LLM Agents & Tooling" ] ],
  [ "Built and shipped a portfolio of AI-driven tools end to end — agents, data apps, integrations.", nil, [ "LLM Agents & Tooling", "Git / GitHub" ] ],
  [ "Learned Ruby on Rails from zero and shipped this site — modeling her own career as real relational data — in a single weekend.", "zero to shipped in one weekend", [ "Ruby on Rails", "Git / GitHub" ] ]
].each_with_index do |(desc, metric, skill_names), i|
  a = indie.accomplishments.create!(description: desc, metric: metric, position: i + 1)
  tag(a, skills, *skill_names)
end

# ---------------------------------------------------------------------------
# Education
# ---------------------------------------------------------------------------
Education.create!(institution: "Greenville Technical College", credential: "Coursework", location: "Greenville, SC", position: 1)
Education.create!(institution: "Southeastern University", credential: "Coursework", location: "Lakeland, FL", position: 2)
Education.create!(
  institution: "Franklin University",
  credential: "B.S., Marketing & Business Administration (dual major)",
  honor: "Summa Cum Laude — GPA 3.95",
  location: "Columbus, OH",
  completed_on: Date.new(2022, 8, 1),
  position: 3
)
Education.create!(
  institution: "Self-directed",
  credential: "Computer science, AI, and Linux systems — ongoing",
  position: 4
)

puts "Seeded: #{Role.count} roles, #{Accomplishment.count} accomplishments, #{Skill.count} skills, #{Education.count} education entries."
