class CarlineController < ApplicationController
  # Illustrative, hand-authored figures for a fictional-but-plausible school — see
  # db/seeds.rb for the disclosure. Nothing here is real family or school data.
  ASSUMED_FAMILIES = 240
  ASSUMED_ANNUAL_TUITION = 9500
  CHURN_PERCENT_PER_COMPLAINT = 1.4 # goofy-but-plausible: each logged complaint nudges churn risk up a notch

  def index
    @days = CarlineDay.ordered
    @complaints = Complaint.ordered

    @avg_wait = @days.average(:avg_wait_minutes)&.round(1)
    @worst_day = @days.max_by(&:worst_wait_minutes)
    @complaint_count = @complaints.count
    @complaints_by_category = @complaints.group(:category).count

    @churn_risk_percent = [ @complaint_count * CHURN_PERCENT_PER_COMPLAINT, 45 ].min.round(1)
    @families_at_risk = (ASSUMED_FAMILIES * @churn_risk_percent / 100.0).round
    @dollars_at_risk = (@families_at_risk * ASSUMED_ANNUAL_TUITION)
  end

  def play
  end
end
