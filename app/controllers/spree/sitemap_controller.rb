module Spree

  include SitemapHelper

  class SitemapController < Spree::StoreController

    def index
      @taxonomy = Spree::Taxonomy.find_by(name: 'Categories')

      # @root_taxons = Spree::Taxon.roots
      #
      # @base_taxons = Spree::Taxon.where(parent: @root_taxons)



    end

  end
end
