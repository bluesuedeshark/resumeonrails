require "test_helper"
require "csv"

class CarlineControllerTest < ActionDispatch::IntegrationTest
  test "index computes headline metrics from the seeded days and complaints" do
    get carline_path

    assert_response :success

    tiles = css_select("section.grid.grid-cols-2 p.text-3xl").map { |el| el.text.strip }
    assert_equal [ "14.1", "40", "6", "12" ], tiles
  end

  test "index reframes complaints against family transport preferences" do
    get carline_path

    assert_response :success
    assert_select "p.text-3xl.font-bold.text-slate-900", text: "2" # repeat-complaint (vocal) families
    assert_select "p.text-3xl.font-bold.text-indigo-600", text: "50%" # of them already want a bus
    assert_select "p.text-3xl.font-bold.text-slate-900", text: "1" # families who'd take a bus today
  end

  test "index without a query renders no search results section" do
    get carline_path

    assert_response :success
    assert_select "p", text: /Nothing matched/, count: 0
    assert_select "p", text: /Results for/, count: 0
  end

  test "index search with a direct term matches carline day notes" do
    get carline_path, params: { q: "SUV" }

    assert_response :success
    assert_select "p", text: 'Results for "SUV"'
    assert_match "Minor SUV backup in the through lane.", response.body
  end

  test "index search expands synonyms and matches both days and complaints" do
    get carline_path, params: { q: "slow" }

    assert_response :success
    items = css_select("li").map { |el| el.text.strip }
    day_results = items.select { |t| t.start_with?("📅") }
    complaint_results = items.select { |t| t.start_with?("💬") }

    assert_equal 1, day_results.size
    assert_equal 4, complaint_results.size
    assert_match "Long wait at pickup during the rain.", response.body
  end

  test "index search with no matches shows the empty state" do
    get carline_path, params: { q: "zzz-no-match" }

    assert_response :success
    assert_select "p", text: /Nothing matched/
  end

  test "index search synonym pulls in complaints by category even without a keyword match on notes" do
    get carline_path, params: { q: "guard" }

    assert_response :success
    items = css_select("li").map { |el| el.text.strip }
    day_results = items.select { |t| t.start_with?("📅") }
    complaint_results = items.select { |t| t.start_with?("💬") }

    assert_equal 0, day_results.size
    assert_equal 2, complaint_results.size
  end

  test "export streams a CSV with the dismissal log and complaint log" do
    get carline_export_path

    assert_response :success
    assert_equal "text/csv", response.media_type

    rows = CSV.parse(response.body)
    assert_equal 23, rows.size
    assert_equal [ "Dismissal log" ], rows[0]
    assert_equal [ "2026-01-01", "3:00 PM", "25", "40", "25", "First week chaos, the line backs onto the highway." ], rows[2]
    assert_equal [ "Complaints" ], rows[15]
    assert_equal [ "2026-01-05", "email", "Crossing guard safety", "2", "Family A", "true", "true" ], rows[17]
  end

  test "report renders a downloadable PDF" do
    get carline_report_path

    assert_response :success
    assert_equal "application/pdf", response.media_type
    assert_match(/attachment/, response.headers["Content-Disposition"])
    assert_match(/carline-report-#{Date.current}\.pdf/, response.headers["Content-Disposition"])
    assert response.body.start_with?("%PDF")
  end

  test "play renders the game shell" do
    get carline_play_path

    assert_response :success
    assert_select "div[data-controller='carline-game']"
    assert_select "canvas[data-carline-game-target='canvas']"
  end
end
