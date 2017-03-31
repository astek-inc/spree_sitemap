module Spree
  module SitemapHelper

    SITE_ROOT = 'https://www.designyourwall.com'

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

    def get_xml
      @builder = Builder::XmlMarkup.new
      @builder.instruct!
      @builder.urlset ({
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
          'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
          'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1',
          'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1',
          'xmlns:geo' => 'http://www.google.com/geo/schemas/sitemap/1.0',
          'xmlns:news' => 'http://www.google.com/schemas/sitemap-news/0.9',
          'xmlns:mobile' => 'http://www.google.com/schemas/sitemap-mobile/1.0',
          'xmlns:pagemap' => 'http://www.google.com/schemas/sitemap-pagemap/1.0',
          'xmlns:xhtml' => 'http://www.w3.org/1999/xhtml',
          'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'
      }) do
        add_homepage
        add_products
        add_taxons
        add_static_pages
      end
      @builder.target!
    end


    def add_homepage
      xml_url SITE_ROOT, Time.now, 'always', 1.0
    end


    def add_taxons
      Spree::Taxon.roots.each { |taxon| add_taxon(taxon) }
    end

    def add_taxon taxon
      xml_url SITE_ROOT+nested_taxons_path(taxon.permalink), taxon.products.last_updated if taxon.permalink.present?
      taxon.children.each { |child| add_taxon child }
    end


    def add_products
      xml_url SITE_ROOT+products_path, active_products.last_updated
      active_products.each { |product| xml_url SITE_ROOT+product_path(product), product.updated_at }
    end

    def active_products
      Spree::Product.active.uniq
    end


    def add_static_pages
      static_pages.each { |url| xml_url SITE_ROOT+url }
    end

    def static_pages
      %w[/contact-us /help /help/returns /help/shipping /help/faq /help/privacy-and-security-policies
            /help/terms-and-conditions /help/how-hang-wallpaper /help/wallpaper-instructions /help/wall-murals-instructions
            /help/grasscloth-wallpaper-instructions /help/glass-beaded-wallpaper-instructions
            /help/flock-wallpaper-instructions /help/hanging-wallpaper /help/dictionary /design-your-own /custom_tips]
    end


    def xml_url loc, lastmod = nil, changefreq = nil, priority = nil
      @builder.url do
        @builder.loc loc
        @builder.lastmod (lastmod.nil? ? Time.now : lastmod).strftime '%Y-%m-%dT%H:%M:%S%:z'
        @builder.changefreq (changefreq.nil? ? 'weekly' : changefreq)
        @builder.priority (priority.nil? ? 0.5 : priority)
      end
    end

  end
end
