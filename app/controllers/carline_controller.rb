require "csv"

class CarlineController < ApplicationController
  # Small hand-built synonym map for keyword search (not real semantic search).
  SEARCH_SYNONYMS = {
    "slow" => %w[wait],
    "suv" => %w[lane],
    "guard" => %w[safety crossing],
    "bike" => %w[safety],
    "loop" => %w[redesign]
  }.freeze

  def index
    load_metrics

    @q = params[:q].presence
    @search = search(@q) if @q
  end

  def report
    load_metrics

    respond_to do |format|
      format.html
      format.pdf do
        pdf = CarlineReportPdf.new(metrics_for_report).render
        send_data pdf, filename: "carline-report-#{Date.current}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def export
    csv = CSV.generate(headers: true) do |rows|
      rows << [ "Dismissal log" ]
      rows << [ "Date", "Dismissal", "Avg wait (min)", "Worst wait (min)", "Cars", "Field notes" ]
      CarlineDay.ordered.each do |d|
        rows << [ d.observed_on, d.dismissal_time, d.avg_wait_minutes, d.worst_wait_minutes, d.cars_in_line, d.note ]
      end
      rows << []
      rows << [ "Complaints" ]
      rows << [ "Date", "Channel", "Category", "Severity", "Family", "Extended day?", "Wants bus?" ]
      Complaint.ordered.includes(:family).each do |c|
        rows << [ c.logged_on, c.channel, c.category, c.severity, c.family_label, c.family&.extended_day, c.family&.wants_bus ]
      end
    end

    send_data csv, filename: "carline-report-#{Date.current}.csv", type: "text/csv"
  end

  def play
  end

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

  # Plain hash so the PDF builder never has to reach into controller ivars.
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

  def search(q)
    terms = ([ q ] + Array(SEARCH_SYNONYMS[q.downcase])).uniq
    day_conditions = terms.map { "note LIKE ?" }.join(" OR ")
    complaint_conditions = terms.map { "category LIKE ?" }.join(" OR ")

    {
      days: CarlineDay.where(day_conditions, *terms.map { |t| "%#{t}%" }),
      complaints: Complaint.includes(:family).where(complaint_conditions, *terms.map { |t| "%#{t}%" })
    }
  end
end
