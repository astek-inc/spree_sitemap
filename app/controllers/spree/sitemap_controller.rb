module Spree
  class SitemapController < Spree::StoreController

    include SitemapHelper

    def index
      @taxonomy = Spree::Taxonomy.find_by(name: 'Categories')
      respond_to do |format|
        format.html
        format.xml { build_xml }
      end
    end

    def build_xml
      data = get_xml_data
      send_data data, type: 'application/x-gzip', filename: 'sitemap.xml.gz'
    end

    def get_xml_data
      Rails.cache.fetch('sitemap.xml.gz', expires_in: 12.hours) do
        ActiveSupport::Gzip.compress get_xml
      end
    end

  end
end
