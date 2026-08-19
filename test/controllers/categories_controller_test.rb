require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "show renders the category's skills and accomplishments" do
    get category_path("ai-dev")

    assert_response :success
    assert_select "h1", text: "AI & Dev"
    assert_select "span.text-xs.bg-purple-100", text: skills(:ruby).name
  end

  test "show orders accomplishments by role position descending, then accomplishment position" do
    get category_path("ai-dev")

    assert_response :success
    descriptions = css_select("li p.text-sm.text-slate-700").map { |el| el.text.strip }
    assert_equal [
      accomplishments(:acc_unordered_highlight).description,
      accomplishments(:acc_highlighted).description
    ], descriptions
  end

  test "show scopes accomplishments to the requested category's skill" do
    get category_path("data-science-and-analytics")

    assert_response :success
    descriptions = css_select("li p.text-sm.text-slate-700").map { |el| el.text.strip }
    assert_equal [ accomplishments(:acc_highlighted).description ], descriptions
  end

  test "show 404s for an unknown category slug" do
    get category_path("does-not-exist")

    assert_response :not_found
  end
end
