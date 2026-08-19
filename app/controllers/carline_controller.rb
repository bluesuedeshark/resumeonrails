require "csv"

class CarlineController < ApplicationController
  include CarlineMetrics

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
    pdf = CarlineReportPdf.new(metrics_for_report).render
    send_data pdf, filename: "carline-report-#{Date.current}.pdf", type: "application/pdf", disposition: "attachment"
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
