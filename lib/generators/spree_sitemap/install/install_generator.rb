module SpreeSitemap
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../templates', __FILE__)

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_sitemap\n", :before => /\*\//, :verbose => true
      end

      desc 'Configures your Rails application for use with spree_sitemap_generator'
      def copy_config
        directory 'config'
      end
    end
  end
end
