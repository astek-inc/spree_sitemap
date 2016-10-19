Deface::Override.new(
    :original => '6a564f90647c896bb94de10ed6a7dcb6290f4da2',
    :virtual_path => 'spree/shared/_footer',
    :name => 'add_site_map_link_to_footer',
    :insert_bottom => 'div.col-lg-8.footer-links > div.row > div.col-md-4:first-child > ul',
    :text => "<%= content_tag(:li, link_to('SITE MAP', '/sitemap')) %>"
)
