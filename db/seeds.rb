# Idempotent — safe to re-run with `bin/rails db:seed`.
# No personal phone/home email included on purpose.

AccomplishmentSkill.destroy_all
Accomplishment.destroy_all
Skill.destroy_all
Role.destroy_all
Education.destroy_all
Profile.destroy_all

# ---------------------------------------------------------------------------
# Profile
# ---------------------------------------------------------------------------
Profile.create!(
  name: "Kaleigh Unger",
  headline: "Senior Analyst - Data, Systems & Applied AI",
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
    "architecting the best solution for a given problem. I also bring a breadth " \
    "of understanding that allows me to keep the big picture in scope and plan a " \
    "strategy that scales - with predictable, measurable, meaningful results that " \
    "integrate even with imperfect systems.",
    "I am very intentional about keeping my knowledge broad, my learning constant, " \
    "my stance agile, and my energy persistent. My job only required me to learn " \
    "SAS, but I've chosen to stay systems-minded by continuing to learn across data " \
    "science, software development, and agentic AI - building real things along " \
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
  github_url: "https://github.com/bluesuedeshark/resumeonrails",
  location: "Greer, SC"
)

# ---------------------------------------------------------------------------
# Skills
# ---------------------------------------------------------------------------
skills = {}
[
  [ "SAS", "Data Science and Analytics" ],
  [ "VBA", "Data Science and Analytics" ],
  [ "R", "Data Science and Analytics" ],
  [ "Python", "Data Science and Analytics" ],
  [ "SQL", "Data Science and Analytics" ],
  [ "K-Means Segmentation", "Data Science and Analytics" ],
  [ "RFM Modeling", "Data Science and Analytics" ],
  [ "Campaign Optimization", "Data Science and Analytics" ],
  [ "Geospatial / Huff Modeling", "Data Science and Analytics" ],
  [ "Ruby on Rails", "AI & Dev" ],
  [ "React", "AI & Dev" ],
  [ "TypeScript", "AI & Dev" ],
  [ "Node.js", "AI & Dev" ],
  [ "LLM Agents & Tooling", "AI & Dev" ],
  [ "Snowflake", "AI & Dev" ],
  [ "Google BigQuery", "AI & Dev" ],
  [ "Vercel", "AI & Dev" ],
  [ "Railway", "AI & Dev" ],
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
  summary: nil
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
  summary: "Hired with no degree and no industry experience - brought in purely " \
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
  summary: "Specialized deeply in structuring blended whole-life products and became " \
           "the agency's trainer on financial product and financial plan design."
)
[
  [ "Taught classes to senior advisors and ran product design for most agents in-office.", nil, [ "Training & Curriculum Design" ] ],
  [ "Built Personal Financial Plans - Social Security projections, amortization schedules, and scenario modeling - for advisors' clients.", nil, [ "Campaign Optimization" ] ],
  [ "Was the only person ever offered an agent's contract without a bachelor's degree, where a degree was a baseline requirement.", "only person offered the contract without a degree", [], true ]
].each_with_index do |(desc, metric, skill_names, hide), i|
  a = nm_planning.accomplishments.create!(description: desc, metric: metric, position: i + 1, hide_from_highlights: !!hide)
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
  summary: "Ten years of SAS-based custom modeling for a variety of industries " \
           "including financial, health, retail, senior-living, and others."
)
[
  [ "Rebuilt the core report shell: automated branding/white-labeling that had been done by hand, and added versioning, conditional logic, and exception-handling.", nil, [ "SAS", "VBA", "Workflow Automation" ] ],
  [ "Consolidated three separately-maintained versions of the same report - often out of sync with each other - into one data-driven shell.", nil, [ "SAS", "Workflow Automation" ] ],
  [ "Became the team's mapping expert: automated per-run maps in PDF output, drive-time measurement, and Huff-model competitor analysis.", nil, [ "Geospatial / Huff Modeling" ] ],
  [ "Co-built, launched, and now maintains a client-facing data portal - self-service data " \
    "exploration that replaced a slow, fully manual request process - and helped shape a new " \
    "data marketplace offering built on top of it.",
    "still in production, still growing", [ "React", "TypeScript", "Node.js", "Python", "Snowflake", "SQL", "Vercel", "Railway", "Supabase" ], 1 ],
  [ "Took on a client's \"group within a group\" segmentation problem: curated a new dataset " \
    "combining their client-provided data with our consumer data, ran it through rigorous " \
    "statistical analysis to determine the right method, then built a custom k-means model " \
    "from scratch.", "400%+ response rate vs. prior efforts", [ "K-Means Segmentation", "SAS" ], 2 ],
  [ "Tasked with optimizing an upcoming campaign: asked the right questions about what " \
    "data they actually had access to, then refactored their existing bucketed RFM process " \
    "into a standard-deviation-based model parsed across more categories, folded into full " \
    "custom modeling blending spending/engagement patterns with household attributes.",
    "record-breaking engagement - the client started paying for this study on every campaign",
    [ "RFM Modeling" ], 3 ],
  [ "Solved an auto-loan campaign with no exact-match variables using reverse-logic modeling on the microgrid variables that were available.", nil, [ "Campaign Optimization" ] ],
  [ "Overhauled a client's manual data-selection process - replacing a slow, manual, copy/paste-and-highlight " \
    "workflow with a tool built on their existing Google BigQuery setup, giving " \
    "them instant feedback on selections and full control over their own parameters.",
    "replaced a fully manual selection process with instant, self-service control",
    [ "Google BigQuery", "Workflow Automation", "SQL" ], 4 ],
  [ "Learned enough R in a single day to execute and validate a client's own scoring model against their internal testing - not R mastery, just enough to get it done.", "same-day turnaround, vs. weeks from other vendors", [ "R" ], 5 ],
  [ "Pushed a client off straight-selects and hot-zips onto modeling; the resulting multi-territory win expanded into all franchises plus a full-year budget for the account.", nil, [ "Campaign Optimization" ] ],
  [ "Tunes variable weighting in production models - catching over- and under-weighted inputs before they skew results.", nil, [] ]
].each_with_index do |(desc, metric, skill_names, highlight), i|
  a = amp.accomplishments.create!(description: desc, metric: metric, position: i + 1, highlight_order: highlight)
  tag(a, skills, *skill_names)
end

indie = Role.create!(
  kind: "role",
  title: "Independent - AI/Product Development and Consulting",
  organization: "bluesuedeshark LLC",
  starts_on: Date.new(2025, 1, 1),
  ends_on: nil,
  current: true,
  position: 7,
  summary: "Self-directed pivot into applied AI and software - shipping things, " \
           "experimenting."
)
[
  [ "Advising a non-technical client on standing up a personal dashboard she owns and controls, while building a bespoke, model-agnostic dashboard proof of concept.", nil, [ "LLM Agents & Tooling" ] ],
  [ "Built and shipped AI-augmented tools end to end - agent-augmented data retrieval and scoring, small internal data apps, system integrations.", nil, [ "LLM Agents & Tooling" ] ],
  [ "Just shipped this site overnight - for a little challenge.", "start to finish, overnight", [ "Ruby on Rails" ] ]
].each_with_index do |(desc, metric, skill_names), i|
  a = indie.accomplishments.create!(description: desc, metric: metric, position: i + 1)
  tag(a, skills, *skill_names)
end

# ---------------------------------------------------------------------------
# Education
# ---------------------------------------------------------------------------
Education.create!(
  institution: "Calvary Christian School",
  credential: "High school diploma",
  honor: "Valedictorian - graduated at 16",
  location: "Myrtle Beach, SC",
  position: 1
)
Education.create!(institution: "Greenville Technical College", credential: "Coursework", location: "Greenville, SC", position: 2)
Education.create!(institution: "Southeastern University", credential: "Coursework", location: "Lakeland, FL", position: 3)
Education.create!(
  institution: "Franklin University",
  credential: "B.S., Marketing & Business Administration (dual major)",
  honor: "Summa Cum Laude - Highest Honors",
  location: "Columbus, OH",
  completed_on: Date.new(2022, 8, 1),
  position: 4
)
Education.create!(
  institution: "Self-directed",
  credential: "Data science and software development - self-built curriculum drawing on MIT " \
              "OpenCourseWare and other rigorous sources, ongoing",
  position: 5
)

# ---------------------------------------------------------------------------
# Carline — deliberately fictional. Nothing here is a real school's data; it's
# generated, not hand-typed, to form a real 6-week time series: 30 school days
# so there's enough data to separate "still learning the routine" (wait times
# genuinely improving) from "this is just how long it takes now" (a plateau
# that doesn't budge). See the disclosure banner on the Carline page itself.
# ---------------------------------------------------------------------------
CarlineDay.destroy_all
Complaint.destroy_all
Family.destroy_all

rng = Random.new(20260815)

school_start = Date.new(2026, 8, 4)
school_days = []
d = school_start
while school_days.size < 30
  school_days << d unless [ 0, 6 ].include?(d.wday)
  d += 1
end

SPIKE_MINUTES = 63.0
PLATEAU_MINUTES = 33.0
DECAY = 0.85

EARLY_NOTES = [
  "Everyone's still learning where to line up.",
  "New families figuring out the flow - lots of confusion at the flagpole.",
  "Kids still working out which line is which.",
  "Staff still working out the choreography too.",
  "First few weeks are always like this, in theory."
].freeze
TRANSITION_NOTES = [
  "A little better than last week, a little at a time.",
  "Regulars are faster now; newer families still slow to load.",
  "Some days good, some days bad - still finding a rhythm.",
  "Improving, but not as fast as anyone hoped."
].freeze
PLATEAU_NOTES = [
  "This is just how it is now. Everyone knows the routine - it's still this slow.",
  "Not an onboarding problem anymore. Everyone's fast at their part; the line is still the line.",
  "Nothing unusual today. It's just this long, every day.",
  "Routine is fully set. Wait time isn't improving further.",
  "Well past the settling-in period - this is the baseline, not a rough patch."
].freeze
SPECIAL_EVENTS = {
  1 => "Rain. Nobody wanted to walk the extra 10 feet.",
  8 => "Two SUVs sharing what should've been one lane.",
  11 => "Crossing guard out sick - visibly slower without her.",
  18 => "Trial run of a one-way loop - modest improvement, didn't hold.",
  23 => "One car stalled at the flagpole for six full minutes."
}.freeze

school_days.each_with_index do |date, i|
  avg = PLATEAU_MINUTES + (SPIKE_MINUTES - PLATEAU_MINUTES) * (DECAY**i) + rng.rand(-4..4)
  avg = avg.round.clamp(20, 70)
  worst = (avg + rng.rand(10..22)).clamp(avg + 8, 85)
  cars = 108 + rng.rand(-6..16)

  note = SPECIAL_EVENTS[i] || case i
                               when 0...6 then EARLY_NOTES.sample(random: rng)
                               when 6...16 then TRANSITION_NOTES.sample(random: rng)
                               else PLATEAU_NOTES.sample(random: rng)
                               end

  CarlineDay.create!(
    observed_on: date,
    dismissal_time: "2:45pm",
    avg_wait_minutes: avg,
    worst_wait_minutes: worst,
    cars_in_line: cars,
    note: note
  )
end

# Families — the related dataset. The first 12 are extended-day families who've
# already said they'd take a bus; complaints are weighted toward this group on
# purpose. That skew is the hidden pattern the combined-dataset section surfaces.
families = {}
loud_pool = []
quiet_pool = []

(1..12).each do |n|
  label = "Family ##{n}"
  wants_bus = n <= 10 # a couple of exceptions so the overlap isn't a suspicious 100%
  families[label] = Family.create!(label: label, extended_day: true, wants_bus: wants_bus, carpool_interested: rng.rand < 0.3)
  loud_pool << label
end

(13..65).each do |n|
  label = "Family ##{n}"
  extended_day = rng.rand < 0.18
  wants_bus = extended_day && rng.rand < 0.35
  families[label] = Family.create!(label: label, extended_day: extended_day, wants_bus: wants_bus, carpool_interested: rng.rand < 0.15)
  quiet_pool << label
end

def weighted_sample(rng, weighted)
  n = rng.rand(weighted.sum { |_, w| w })
  weighted.each { |val, w| return val if (n -= w) < 0 }
  weighted.first.first
end

CATEGORIES = [ [ "wait time", 5 ], [ "lane discipline", 2 ], [ "communication", 1 ], [ "safety", 1 ] ].freeze
CHANNELS = %w[email phone].freeze

school_days.each_with_index do |date, i|
  daily_count = (1 + (i * 0.16) + rng.rand(-0.5..0.5)).round.clamp(0, 6)
  daily_count.times do
    family_label = rng.rand < 0.6 ? loud_pool.sample(random: rng) : quiet_pool.sample(random: rng)
    Complaint.create!(
      logged_on: date,
      channel: CHANNELS.sample(random: rng),
      category: weighted_sample(rng, CATEGORIES),
      severity: rng.rand(1..3),
      family_label: family_label,
      family: families.fetch(family_label)
    )
  end
end

puts "Seeded: #{Role.count} roles, #{Accomplishment.count} accomplishments, #{Skill.count} skills, #{Education.count} education entries, #{CarlineDay.count} carline days, #{Complaint.count} complaints, #{Family.count} families."
