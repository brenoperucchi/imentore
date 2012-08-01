module CategoriesHelper

  mattr_accessor :children, :aux
  self.children = false

  def categories_descendants(descendants)
    descendants.each do |descendant|
      concat(content_tag(:tr) do
        concat(content_tag(:td, descendant.ancestors.count))
        concat(content_tag(:td, :style=>"white-space:nowrap;", id: 'name') do
          descendant.ancestors.count.times do
            concat(content_tag(:i, '', :class=> 'icon-black icon-arrow-right'))
          end
          concat(descendant.name)
        end)
        concat(content_tag(:td, descendant.handle, id: 'handle'))
        concat(content_tag(:td, descendant.products.size))
        concat(content_tag(:td) do
          concat(tag(:input, :name=>"ordering", :class=> 'span1'))
        end)
        concat(content_tag(:td) do
          concat(content_tag(:a, 'Edit', :href=>edit_admin_category_path(descendant), :class=>'btn', id: 'edit_category', :category_id =>descendant.id, parent_id: descendant.parent_id) do
            concat(content_tag(:i,'',:class=> 'icon-black icon-edit'))
            concat(' ' + I18n.t(:edit))
          end)
          concat(" ")
          concat(content_tag(:a, 'Destroy', :href=>admin_category_path(descendant), 'data-method'=>'delete', :class=>'btn btn-danger' ) do
            concat(content_tag(:i,'',:class=> 'icon-white icon-trash'))
            concat(' ' + I18n.t(:remove))
          end)
        end)

      end)
      if descendant.has_children?
        categories_descendants(descendant.children)
      end
    end
  end

  def categories_table(collection)
    content_tag(:table, class: 'table table-stripped table-condensed') do
      concat(content_tag(:thead) do
        content_tag(:tr) do
          concat(content_tag(:th, I18n.t(:level)))
          concat(content_tag(:th, I18n.t(:name, :style=>"width:40px;")))
          concat(content_tag(:th, I18n.t(:handle)))
          concat(content_tag(:th, I18n.t(:products)))
          concat(content_tag(:th, I18n.t(:ordering)))
          concat(content_tag(:th, I18n.t(:actions)))
        end
      end)
      concat(content_tag(:tbody) do
        collection.roots.collect do |category|
          concat(content_tag(:tr) do
            concat(content_tag(:td, category.ancestors.count))
            concat(content_tag(:td, id: 'name') do
              concat(content_tag(:strong, category.name))
            end)
            concat(content_tag(:td, category.handle, id: 'handle'))
            concat(content_tag(:td, category.products.size))
            concat(content_tag(:td))
            concat(content_tag(:td) do
              concat(content_tag(:a, 'Edit', :href=>edit_admin_category_path(category), :class=>'btn', id: 'edit_category', :category_id =>category.id, parent_id: category.parent_id) do
                concat(content_tag(:i,'',:class=> 'icon-black icon-edit'))
                concat(' ' + I18n.t(:edit))
              end)
              concat(" ")
              concat(content_tag(:a, 'Destroy', :href=>admin_category_path(category), 'data-method'=> 'delete', :class=>'btn btn-danger' ) do
                concat(content_tag(:i,'',:class=> 'icon-white icon-trash'))
                concat(' ' + I18n.t(:remove))
              end)
            end)
            categories_descendants(category.children)
          end)
          # concat(content_tag(:tr){
          #   if not category.is_root?
          #     concat(content_tag(:td, :style=>"white-space:nowrap;") do
          #       category.ancestors.count.times do
          #         concat(content_tag(:i, '', :class=> 'icon-black icon-arrow-right'))
          #       end
          #     end)
          #   else
          #     concat(content_tag(:td))
          #   end
          #   concat(content_tag(:td, category.ancestors.count))
          #   concat(content_tag(:td, category.name))
          #   concat(content_tag(:td, category.handle))
          # })
        end
      end)
    end
      # content_tag(:tr) do
      #   categories.each do |category|
      #     concat(content_tag(:td) do
      #       category.name
      #       if self.children
      #         tag(:i, class: 'icon-black icon-arrow-right')
      #         self.children = false
      #       end
      #       content_tag(:td, category.name)
      #     end)
      #     if category.has_children?
      #       self.children = true
      #       categories_table(category.children)
      #       binding.pry
      #     end
      #   end
      # end
  end

end