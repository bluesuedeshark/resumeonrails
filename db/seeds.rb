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
# 2026-08-15 rewrite. Portal/marketplace specifics deliberately live in "Some
# things I do" + Timeline instead of here — intro stays at the identity level.
Profile.create!(
  name: "Kaleigh Unger",
  headline: "Senior Analyst — Data, Systems & Applied AI",
  tagline: [
    "I turn messy data into meaningful insights.",
    "I optimize systems for usability and scale.",
    "I utilize AI thoughtfully and intentionally."
  ].join("\n"),
  intro: [
    "My career spans almost 20 years in analytical disciplines across multiple " \
    "industries, including 10 years in data science, creating and running custom " \
    "modeling solutions for financial, health, retail, senior-living, and other " \
    "clients. I have a depth of technical expertise that drives me to ensure I'm " \
    "architecting the best solution for a given problem, while also bringing a " \
    "breadth of understanding that allows me to keep the big picture in scope and " \
    "plan a strategy that doesn't just work for the problem at hand, but scales " \
    "long-term — with predictable, measurable, and meaningful results that hold " \
    "up at scale and integrate even within messy systems.",
    "I am very intentional about keeping my knowledge broad, my learning constant, " \
    "my stance agile, and my energy persistent. My job only required me to learn " \
    "SAS, but I've chosen to stay systems-minded by continuing to learn across data " \
    "science, software development, and agentic AI — building real things along " \
    "the way (more in the timeline), and, in my free time, helping an agentic " \
    "startup research agent behavior, build capability ladders for testing, and " \
    "hone agent behavior in live systems.",
    "I love learning, I love growing, and I love helping. I couple my driven, " \
    "detail-oriented nature with a commitment to serve others, bringing rigorous " \
    "self-discipline to my own work while remaining deeply invested in the " \
    "success, needs, and growth of the team around me. Passion, courage, and " \
    "integrity drive me to succeed in the face of obstacles, navigate ambiguity " \
    "with confidence, and exceed expectations consistently."
  ].join("\n\n"),
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
  [ "React", "AI & Dev" ],
  [ "Node.js", "AI & Dev" ],
  [ "LLM Agents & Tooling", "AI & Dev" ],
  [ "Git / GitHub", "AI & Dev" ],
  [ "Snowflake", "AI & Dev" ],
  [ "Google BigQuery", "AI & Dev" ],
  [ "Vercel", "AI & Dev" ],
  [ "Supabase", "AI & Dev" ],
  [ "Linux", "AI & Dev" ],
  [ "Workflow Automation", "Systems & Process" ],
  [ "Training & Curriculum Design", "Systems & Process" ],
  [ "Process Reverse-Engineering", "Systems & Process" ],
  [ "FINRA Licensing (6, 63, 7)", "Learning & Credentials" ],
  [ "Risk Insurance License (P&C)", "Learning & Credentials" ],
  [ "Life & Health Insurance License", "Learning & Credentials" ]
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
  [ "Earned a property & casualty insurance license.", [ "Risk Insurance License (P&C)" ] ],
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
  [ "Broke the agency record for applications submitted with zero errors by a single representative.", "agency record, zero errors", [], true ],
  [ "Earned a life & health insurance license, then FINRA Series 6, 63, and 7.", nil, [ "FINRA Licensing (6, 63, 7)", "Life & Health Insurance License" ] ],
  [ "Promoted from assistant to associate financial representative, with authority to walk clients through and sign contracts.", nil, [] ]
].each_with_index do |(desc, metric, skill_names, hide), i|
  a = nm_associate.accomplishments.create!(description: desc, metric: metric, position: i + 1, hide_from_highlights: !!hide)
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
  [ "Co-built, launched, and now maintains a client-facing data portal — self-service data " \
    "exploration that replaced a slow, fully manual request process — and helped shape a new " \
    "data marketplace offering built on top of it.",
    "still in production, still growing", [ "React", "Node.js", "Python", "Snowflake", "SQL" ], 1 ],
  [ "Took on a client's \"group within a group\" segmentation problem: curated a new dataset " \
    "combining their client-provided data with our consumer data, ran it through rigorous " \
    "statistical analysis to determine the right method, then built a custom k-means model " \
    "from scratch.", "400%+ response rate vs. prior efforts", [ "K-Means Segmentation", "SAS" ], 2 ],
  [ "Took on a client's campaign-optimization problem: asked the right questions about what " \
    "data they actually had access to, then refactored their existing bucketed RFM process " \
    "into a standard-deviation-based model parsed across more categories, folded into full " \
    "custom modeling blending spending/engagement patterns with household attributes.",
    "record-breaking engagement — the client started paying for this study on every campaign",
    [ "RFM Modeling" ], 3 ],
  [ "Solved an auto-loan campaign with no exact-match variables using reverse-logic modeling on the microgrid variables that were available.", nil, [ "Campaign Optimization" ] ],
  [ "Learned enough R in a single day to execute and validate a client's own scoring model against their internal testing — not R mastery, just enough to get it done.", "same-day turnaround, vs. weeks from other vendors", [ "R" ] ],
  [ "Pushed a client off straight-selects and hot-zips onto modeling; the resulting multi-territory win expanded into all franchises plus a full-year budget for the account.", nil, [ "Campaign Optimization" ] ],
  [ "Tunes variable weighting in production models - catching over- and under-weighted inputs before they skew results.", nil, [] ],
  [ "Overhauled a client's manual data-selection process — replacing a slow, manual, copy/paste-and-highlight " \
    "workflow with a tool built on their existing Google BigQuery setup, giving " \
    "them instant feedback on selections and full control over their own parameters.",
    "replaced a fully manual selection process with instant, self-service control",
    [ "Google BigQuery", "Workflow Automation", "SQL" ] ]
].each_with_index do |(desc, metric, skill_names, highlight), i|
  a = amp.accomplishments.create!(description: desc, metric: metric, position: i + 1, highlight_order: highlight)
  tag(a, skills, *skill_names)
end

indie = Role.create!(
  kind: "role",
  title: "Independent — AI/Product Development and Consulting",
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
  [ "Built and shipped AI-augmented tools end to end — agent-augmented data retrieval and scoring, small internal data apps, system integrations.", nil, [ "LLM Agents & Tooling", "Git / GitHub" ] ],
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
  honor: "Summa Cum Laude — Highest Honors",
  location: "Columbus, OH",
  completed_on: Date.new(2022, 8, 1),
  position: 3
)
Education.create!(
  institution: "Self-directed",
  credential: "Data science and software development — self-built curriculum drawing on MIT " \
              "OpenCourseWare and other rigorous sources, ongoing",
  position: 4
)

# ---------------------------------------------------------------------------
# Carline — deliberately fictional. Nothing here is a real school's data;
# hand-authored to be plausible and a little funny. See the disclosure banner
# on the Carline page itself.
# ---------------------------------------------------------------------------
CarlineDay.destroy_all
Complaint.destroy_all
Family.destroy_all

[
  [ Date.new(2026, 8, 4), "2:45pm", 14, 22, 118, "First week jitters — everyone forgot where to line up." ],
  [ Date.new(2026, 8, 5), "2:45pm", 17, 29, 121, "Rain. Nobody wanted to walk the extra 10 feet." ],
  [ Date.new(2026, 8, 6), "2:45pm", 12, 19, 115, "Smoothest day of the week, for reasons unclear." ],
  [ Date.new(2026, 8, 7), "2:45pm", 19, 31, 124, "One car stalled at the flagpole for six full minutes." ],
  [ Date.new(2026, 8, 8), "2:45pm", 11, 16, 109, "Half-day Friday — line cleared before it really started." ],
  [ Date.new(2026, 8, 11), "2:45pm", 16, 24, 119, "Normal Monday chaos." ],
  [ Date.new(2026, 8, 12), "2:45pm", 15, 21, 120, "Crossing guard out sick — visibly slower without her." ],
  [ Date.new(2026, 8, 13), "2:45pm", 21, 34, 126, "Two SUVs sharing what should've been one lane." ],
  [ Date.new(2026, 8, 14), "2:45pm", 13, 18, 117, "Trial run of a one-way loop — modest improvement." ]
].each do |observed_on, dismissal_time, avg_wait, worst_wait, cars, note|
  CarlineDay.create!(
    observed_on: observed_on,
    dismissal_time: dismissal_time,
    avg_wait_minutes: avg_wait,
    worst_wait_minutes: worst_wait,
    cars_in_line: cars,
    note: note
  )
end

# Families — the "related dataset" that, combined with the complaint log, reveals the
# hidden pattern: repeat complainers cluster with extended-day families who already
# want a bus. Vocal (2+ complaints): #14, #22, #40. Everyone else is quieter background.
families = {}
[
  # label,        extended_day, wants_bus, carpool_interested
  [ "Family #14", true,  true,  false ],
  [ "Family #22", true,  true,  true ],
  [ "Family #40", false, false, true ],
  [ "Family #3",  false, false, false ],
  [ "Family #9",  true,  false, false ],
  [ "Family #31", false, false, false ],
  [ "Family #6",  true,  true,  false ],
  [ "Family #1",  false, false, false ],
  [ "Family #2",  false, false, true ],
  [ "Family #4",  true,  false, false ],
  [ "Family #5",  false, false, false ],
  [ "Family #7",  false, false, false ],
  [ "Family #8",  true,  false, false ],
  [ "Family #10", false, false, false ],
  [ "Family #11", false, false, false ],
  [ "Family #12", true,  true,  false ],
  [ "Family #13", false, false, false ],
  [ "Family #15", false, false, false ],
  [ "Family #16", false, true,  false ],
  [ "Family #17", false, false, false ]
].each do |label, extended_day, wants_bus, carpool_interested|
  families[label] = Family.create!(label: label, extended_day: extended_day, wants_bus: wants_bus, carpool_interested: carpool_interested)
end

[
  [ Date.new(2026, 8, 5), "email", "wait time", 2, "Family #14" ],
  [ Date.new(2026, 8, 7), "phone", "wait time", 3, "Family #22" ],
  [ Date.new(2026, 8, 7), "email", "lane discipline", 2, "Family #3" ],
  [ Date.new(2026, 8, 8), "email", "wait time", 1, "Family #40" ],
  [ Date.new(2026, 8, 11), "phone", "communication", 1, "Family #9" ],
  [ Date.new(2026, 8, 12), "email", "wait time", 2, "Family #22" ],
  [ Date.new(2026, 8, 13), "phone", "lane discipline", 3, "Family #14" ],
  [ Date.new(2026, 8, 13), "email", "wait time", 3, "Family #31" ],
  [ Date.new(2026, 8, 13), "email", "safety", 2, "Family #6" ],
  [ Date.new(2026, 8, 14), "phone", "wait time", 1, "Family #40" ]
].each do |logged_on, channel, category, severity, family_label|
  Complaint.create!(
    logged_on: logged_on,
    channel: channel,
    category: category,
    severity: severity,
    family_label: family_label,
    family: families.fetch(family_label)
  )
end

puts "Seeded: #{Role.count} roles, #{Accomplishment.count} accomplishments, #{Skill.count} skills, #{Education.count} education entries, #{CarlineDay.count} carline days, #{Complaint.count} complaints, #{Family.count} families."
