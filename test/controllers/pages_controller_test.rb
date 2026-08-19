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
    assert_equal [ "Data Science and Analytics", "AI & Dev" ], categories
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

  test "timeline lists education in position order" do
    get timeline_path

    assert_response :success
    institutions = css_select("ul.space-y-2 span.font-medium.text-slate-900").map { |el| el.text.strip }
    assert_equal [
      educations(:first_degree).institution,
      educations(:second_credential).institution
    ], institutions
  end
end
