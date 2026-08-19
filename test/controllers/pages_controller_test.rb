require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home renders the current profile" do
    get root_path

    assert_response :success
    assert_select "h1", text: profiles(:primary).name
    assert_select "p", text: profiles(:primary).headline
  end

  test "home lists skill categories in CATEGORY_ORDER, not alphabetically" do
    get root_path

    assert_response :success
    categories = css_select("section a.rounded-full").map { |el| el.text.strip }
    assert_equal [ "Data Science and Analytics", "AI & Dev", "Learning & Credentials" ], categories
  end

  test "home features only highlighted accomplishments, in highlight order" do
    get root_path

    assert_response :success
    descriptions = css_select("#highlights p.text-sm.text-slate-700").map { |el| el.text.strip }
    assert_equal [
      accomplishments(:acc_highlighted).description,
      accomplishments(:acc_unordered_highlight).description
    ], descriptions
    assert_no_match(/#{Regexp.escape(accomplishments(:acc_hidden).description)}/, response.body)
    assert_no_match(/#{Regexp.escape(accomplishments(:acc_no_metric).description)}/, response.body)
  end

  test "timeline renders roles most recent first" do
    get timeline_path

    assert_response :success
    titles = css_select("div.border-l-2 h2").map { |el| el.text.strip }
    assert_equal [ roles(:past_role).title, roles(:current_role).title ], titles
  end

  test "timeline lists education newest first, matching how roles are ordered" do
    get timeline_path

    assert_response :success
    headlines = css_select("#education ~ ul span.font-medium.text-slate-900").map { |el| el.text.strip }
    assert_equal [
      educations(:second_credential).headline,
      educations(:first_degree).headline
    ], headlines
  end

  test "timeline skills roster uses the same vocabulary as the category page" do
    get timeline_path

    assert_response :success
    roster = css_select("#skills ~ div p.text-purple-700").map { |el| el.text.strip }
    assert_includes roster, "Coursework · Bachelor's Degree · Example License"
  end

  test "print renders one document with every section, using the print layout" do
    get print_path

    assert_response :success
    assert_select "header nav", count: 0, message: "print layout must not carry the site nav"
    assert_select "h2.print-h2", text: "Skills"
    assert_select "h2.print-h2", text: "Experience"
    assert_select "h2.print-h2", text: "Education"
    assert_select "article.print-doc"
  end

  test "print hides the toolbar from paper and keeps the Carline appendix opt-in" do
    get print_path

    assert_response :success
    assert_select ".no-print"
    assert_select "#include-carline"
    assert_select "#carline-appendix"
  end

  test "every page offers the print link" do
    [ root_path, timeline_path ].each do |path|
      get path
      assert_select "a[href=?]", print_path, text: "Print"
    end
  end

  test "timeline links Skills to its section, plus one back to top" do
    get timeline_path

    assert_response :success
    assert_select "a[href='#skills']", text: "Skills"
    assert_select "a[href='#top']", count: 1
    assert_select "h2#skills"
  end
end
