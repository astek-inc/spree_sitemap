module Spree
  module SitemapHelper

    def taxons_list(parent_taxon, level = 5)

      return '' if level < 1 || parent_taxon.leaf?

      content_tag :ul, { class: 'level-' + level.to_s } do
        taxons = parent_taxon.children.map do |taxon|
          # css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'list-group-item active' : 'list-group-item'

          class_name = 'level-' + level.to_s
          if level < 5 && taxon.children.empty?
            class_name << ' no-children'
          end
          content_tag(:li, link_to(taxon.name, seo_url(taxon)) + taxons_list(taxon, level - 1), { class: class_name })
        end

        safe_join(taxons, "\n")
      end

    end

  end
end
