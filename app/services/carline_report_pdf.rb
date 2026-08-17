require "prawn"
require "prawn/table"

# Builds the same findings shown in the Carline HTML report as a downloadable
# PDF. Pure-Ruby (Prawn) on purpose — no wkhtmltopdf/headless-Chrome binary
# to bake into the Docker image.
class CarlineReportPdf
  INK = "1E293B"
  MUTED = "64748B"
  INDIGO = "4F46E5"
  PURPLE = "7C3AED"

  def initialize(metrics)
    @m = metrics
  end

  def render
    Prawn::Document.new(page_size: "LETTER", margin: 56) do |pdf|
      header(pdf)
      headline_metrics(pdf)
      finding_baseline(pdf)
      finding_reframe(pdf)
      solution_options(pdf)
      footer(pdf)
    end.render
  end

  private

  def header(pdf)
    pdf.fill_color INDIGO
    pdf.text "CARLINE, DATA-DRIVEN", size: 10, style: :bold, character_spacing: 1.5
    pdf.fill_color INK
    pdf.move_down 4
    pdf.text "Executive Summary", size: 22, style: :bold
    pdf.fill_color MUTED
    pdf.text "Generated #{Date.current.strftime('%B %-d, %Y')} · Illustrative data, real methodology " \
              "(see the live page for the full disclosure)", size: 9
    pdf.move_down 20
  end

  def headline_metrics(pdf)
    tiles = [
      [ "#{@m[:avg_wait]}", "avg. wait, minutes" ],
      [ "#{@m[:worst_wait]}", "worst single wait" ],
      [ "#{@m[:complaint_count]}", "complaints logged" ],
      [ "#{@m[:days_observed]}", "dismissals observed" ]
    ]
    col_width = pdf.bounds.width / 4.0
    # Capture the starting y ONCE — re-reading pdf.cursor inside the loop
    # reflects wherever the PREVIOUS tile's content left it, not a shared row.
    row_top = pdf.cursor
    tiles.each_with_index do |(value, label), i|
      pdf.bounding_box([ i * col_width, row_top ], width: col_width - 10, height: 46) do
        pdf.fill_color INDIGO
        pdf.text value.to_s, size: 20, style: :bold
        pdf.fill_color MUTED
        pdf.text label, size: 8
      end
    end
    pdf.move_cursor_to row_top - 66
  end

  def finding_baseline(pdf)
    section_heading(pdf, "Finding 1 - baseline, not a point average")
    body(pdf,
      "Wait time decays over the school-year adoption period, then stabilizes. The stabilized " \
      "value is the honest baseline to plan against, #{@m[:plateau_baseline]} minutes, not the " \
      "elevated average from the decay period."
    )
  end

  def finding_reframe(pdf)
    section_heading(pdf, "Finding 2 - the reframe")
    body(pdf,
      "#{@m[:vocal_bus_ready_percent]}% of repeat-complaint families are already extended-day " \
      "families who've separately said they want a bus. Complaint frequency correlates with " \
      "bus-readiness rather than being randomly distributed across the population, #{@m[:bus_ready_family_count]} " \
      "families total (of #{@m[:total_families]}) would take a bus today. This reframes part of " \
      "the problem from pure carline throughput to unmet transport demand."
    )
    pdf.fill_color MUTED
    pdf.text "Honest caveat: a real 95% confidence interval at a ±5% margin needs roughly 384 " \
              "families surveyed; this sample has #{@m[:vocal_family_count]}. This page sketches the " \
              "method, it isn't a finished study.", size: 8, style: :italic
    pdf.fill_color INK
    pdf.move_down 18
  end

  def solution_options(pdf)
    section_heading(pdf, "Three independent levers, not mutually exclusive")
    data = [
      [ "Option", "Approach", "Effort", "Timeline", "Effect" ],
      [ "A", "Earlier, organized check-in", "Low-medium", "Weeks", "~15% wait reduction" ],
      [ "B", "Stagger dismissal by grade", "Medium", "Weeks", "~20% wait reduction" ],
      [ "C", "Afternoon bus route for bus-ready families", "High", "A semester", "#{@m[:bus_ready_family_count]} cars removable" ]
    ]
    pdf.table(data, width: pdf.bounds.width) do |t|
      t.row(0).font_style = :bold
      t.row(0).background_color = "EEF2FF"
      t.row(0).text_color = INDIGO
      t.cells.padding = 8
      t.cells.size = 9
      t.cells.borders = [ :bottom ]
      t.cells.border_color = "E2E8F0"
      t.column(0).width = 60
    end
    pdf.move_down 20
  end

  def footer(pdf)
    pdf.stroke_color "E2E8F0"
    pdf.stroke_horizontal_rule
    pdf.move_down 8
    pdf.fill_color MUTED
    pdf.text "resumeonrails.com/carline · Kaleigh Unger", size: 8
  end

  def section_heading(pdf, text)
    pdf.fill_color INK
    pdf.text text, size: 13, style: :bold
    pdf.move_down 6
  end

  def body(pdf, text)
    pdf.fill_color INK
    pdf.text text, size: 10, leading: 3
    pdf.move_down 12
  end
end
