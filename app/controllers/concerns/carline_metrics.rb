# The Carline analysis numbers, shared by the Carline page, its PDF report, and
# the printable resume's optional appendix — so all three quote the same figures.
module CarlineMetrics
  extend ActiveSupport::Concern

  private

  def load_metrics
    @days = CarlineDay.ordered
    @complaints = Complaint.ordered.includes(:family)

    @avg_wait = @days.average(:avg_wait_minutes)&.round(1)
    @worst_day = @days.order(worst_wait_minutes: :desc).first
    @complaint_count = @complaints.count
    @complaints_by_category = @complaints.group(:category).count

    # Where the "school start effect" stops explaining the wait time: the first
    # day the rolling average is within 15% of where the last 10 days settle.
    days_list = @days.to_a
    @plateau_baseline = (days_list.last(10).sum(&:avg_wait_minutes) / 10.0).round(1)
    @plateau_start = days_list.find { |d| d.avg_wait_minutes <= @plateau_baseline * 1.15 }

    # The reframe: combine the complaint log with a related dataset (family
    # transport preferences) and see what falls out.
    @total_families = Family.count
    @vocal_families = Family.vocal.to_a
    @vocal_bus_ready = @vocal_families.select { |f| f.extended_day? && f.wants_bus? }
    @vocal_bus_ready_percent = @vocal_families.any? ? ((@vocal_bus_ready.size.to_f / @vocal_families.size) * 100).round : 0
    @bus_ready_families = Family.where(extended_day: true, wants_bus: true)
    @extended_day_count = Family.where(extended_day: true).count

    # Option C's wait-time effect is the one real number here: bus-ready
    # families as a share of the average line. A/B's effects are disclosed
    # estimates in the view — no equivalent controlled measurement exists.
    avg_cars = @days.average(:cars_in_line).to_f
    @effect_c = avg_cars.positive? ? (@bus_ready_families.count / avg_cars).round(3) : 0
  end

  def metrics_for_report
    {
      avg_wait: @avg_wait,
      worst_wait: @worst_day&.worst_wait_minutes,
      complaint_count: @complaint_count,
      days_observed: @days.count,
      plateau_baseline: @plateau_baseline,
      vocal_family_count: @vocal_families.size,
      vocal_bus_ready_percent: @vocal_bus_ready_percent,
      bus_ready_family_count: @bus_ready_families.count,
      total_families: @total_families
    }
  end
end
