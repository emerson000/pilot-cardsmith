class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :parent_id, :subcategory_count

  attribute :subcategories

  def subcategories
    object.subcategories.map do |subcategory|
      CategorySerializer.new(subcategory, scope: scope, root: false, adapter: :json).as_json
    end
  end

  attribute :subcategory_count
  def subcategory_count
    object.subcategories.size
  end
end
