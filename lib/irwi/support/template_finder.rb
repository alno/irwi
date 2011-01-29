module Irwi::Support::TemplateFinder

  protected

  def template_dir(template)
    dir = respond_to?( :controller_path ) ? controller_path : controller.controller_path
    dir = 'base_wiki_pages' if Dir.glob( "app/views/#{dir}/#{template}.html.*" ).empty? # Select default if there are no template in resource directory
    dir
  end

end
