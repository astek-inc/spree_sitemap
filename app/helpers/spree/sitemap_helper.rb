module Spree
  module SitemapHelper

    def taxons_list(parent_taxon, level = 5)
      return '' if level < 1 || parent_taxon.leaf?
      content_tag :ul do
        taxons = parent_taxon.children.map do |taxon|
          content_tag(:li, link_to(taxon.name, seo_url(taxon)) + taxons_list(taxon, level - 1))
        end
        safe_join(taxons, $/) + $/
      end
    end

    def help_links_list
      help_urls = [
        { href: '/help/terms-and-conditions', label: 'Terms And Conditions' },
        { href: 'help/shipping', label: 'Shipping and Delivery' },
        { href: '/help/returns', label: 'Returns and Refunds' },
        { href: 'help/privacy-and-security-policies', label: 'Privacy And Security' },
        { href: '/help/faq', label: 'Question & Answers' },
        { href: '/help/dictionary', label: 'Dictionary' },
        { href: '/help/wallpaper-instructions', label: 'Wallpaper Installation' },
        { href: '/help/wall-murals-instructions', label: 'Mural Installation' },
        { href: '/help/grasscloth-wallpaper-instructions', label: 'Grasscloth Installation' },
        { href: '/help/glass-beaded-wallpaper-instructions', label: 'Glassbead Wallcovering Installation' },
        { href: '/help/flock-wallpaper-instructions', label: 'Flock and Screen-printed Wallcovering Installation' },
        { href: '/help/how-hang-wallpaper', label: 'Custom Printed Wallcovering Installation' },
        { href: '/help/hanging-wallpaper', label: 'Wallpaper Installation Tutorial Videos' },
        { href: 'design-your-own', label: 'Design Your Own Wallpaper!' }
      ]

      content_tag :ul do
        links = help_urls.map do |link|
          content_tag(:li, link_to(link[:label], link[:href]))
        end
        safe_join(links, $/) + $/
      end
    end

    def blog_links_list
      content_tag :ul do
        links = [content_tag(:li, link_to('Blog', blog_root_path))]
        links << Spree::Blogit::Post.for_feed.map do |post|
          content_tag(:li, link_to(post.title, blog_post_path(post.slug)))
        end
        safe_join(links, $/) + $/
      end
    end

  end
end
