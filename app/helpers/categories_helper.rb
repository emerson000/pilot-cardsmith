module CategoriesHelper
  def render_category_tree(category_tree, level = 0)
    category_tree.map do |node|
      concat(content_tag(:tr) do
        concat(content_tag(:td, class: "limit-text", title: node[:category].name) do
          concat ("&nbsp;" * level * 10).html_safe
          concat '<i class="fa-solid fa-chevron-down"></i>&nbsp;&nbsp;'.html_safe if node[:subcategories].any?
          concat node[:category].name
        end)
        concat(content_tag(:td, class: "show-for-medium") do
          render partial: "categories/category", locals: { category: node[:category] }
        end)
      end)
      if node[:subcategories].any?
        render_category_tree(node[:subcategories], level + 1)
      end
    end.join.html_safe
  end
end
