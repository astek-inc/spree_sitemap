module Spree

  include SitemapHelper

  class SitemapController < Spree::StoreController

    # Mime::Type.register_alias 'application/x-gzip', :gz


    def index
      @taxonomy = Spree::Taxonomy.find_by(name: 'Categories')

      @root_taxons = Spree::Taxon.roots
      #
      # @base_taxons = Spree::Taxon.where(parent: @root_taxons)

      respond_to do |format|
        format.html
        format.xml { create_xml }
      end

    end

    def create_xml
      # request.env['HTTP_ACCEPT_ENCODING'] = 'gzip'
      # Zlib::Deflate.deflate render

      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.urlset ({
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

        xml.url do
          xml.loc 'https://www.designyourwall.com'
          xml.lastmod Time.now.strftime "%Y-%m-%dT%H:%M:%S%:z"
          xml.changefreq 'always'
          xml.priority 1.0
        end

        # @taxonomy.taxons.each do |taxon|
        @root_taxons.each do |taxon|
          xml.url do
            xml.loc 'https://www.designyourwall.com/t/'+taxon.permalink
            xml.lastmod taxon.updated_at.strftime "%Y-%m-%dT%H:%M:%S%:z"
            xml.changefreq 'weekly'
            xml.priority 0.5
          end

          taxon.children.each do |child|
            xml.url do
              xml.loc 'https://www.designyourwall.com/t/'+child.permalink
              xml.lastmod child.updated_at.strftime "%Y-%m-%dT%H:%M:%S%:z"
              xml.changefreq 'weekly'
              xml.priority 0.5
            end
          end


        end


        # '/contact-us'
        #
        # '/help'
        # '/help/returns'
        # '/help/shipping'
        # '/help/faq'
        # '/help/privacy-and-security-policies'
        # '/help/terms-and-conditions'
        #
        # '/help/how-hang-wallpaper'
        # '/help/wallpaper-instructions'
        # '/help/wall-murals-instructions'
        # '/help/grasscloth-wallpaper-instructions'
        # '/help/glass-beaded-wallpaper-instructions'
        # '/help/flock-wallpaper-instructions'
        # '/help/hanging-wallpaper'
        # '/help/dictionary'
        #
        # '/design-your-own'
        # '/custom_tips'



        # @posts.each do |post|
        #   xml.post do
        #     xml.title post.title
        #     xml.body post.body
        #     xml.published_at post.published_at
        #     xml.comments do
        #       post.comments.each do |comment|
        #         xml.comment do
        #           xml.body comment.body
        #         end
        #       end
        #     end
        #   end
        # end
      end

      xml_data = xml.target!
      compressed = ActiveSupport::Gzip.compress xml_data
      send_data compressed, type: 'application/x-gzip', filename: 'sitemap.xml.gz'

    end

  end
end
