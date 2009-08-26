module Irwi::Helpers::WikiPagesHelper
  
  include Irwi::Support::TemplateFinder
  
  # Edit form for wiki page model
  def wiki_page_form( config = {}, &block )
    form_for( :page, @page, { :url => url_for( :action => :update ) }.merge!( config ), &block )
  end
  
  def wiki_page_edit_path
    url_for( :action => :edit )
  end
  
  def wiki_page_history_path
    url_for( :action => :history )
  end
  
  def wiki_page_compare_path
    url_for( :action => :compare )
  end
  
  def wiki_page_path
    url_for( :action => :show )
  end
  
  def wiki_content( text )
    sanitize( Irwi.config.formatter.format( text ) )
  end
  
  def wiki_diff( prev_text, next_text )
    "#{prev_text} - #{next_text}"
  end
  
  def wiki_user( user )
    return '&lt;Unknown&gt;' if user.nil?
    
    "User##{user.id}"
  end
  
  ##
  # Instead of having to translate strings and defining a default value:
  #
  #     t("Hello World!", :default => 'Hello World!')
  #
  # We define this method to define the value only once:
  #
  #     _("Hello World!")
  #
  # Note that interpolation still works ...
  #
  #     _("Hello {{world}}!", :world => @world)
  #
  def _(msg, *args)
    config = args.extract_options!
    config[:default] = msg
    I18n.t(msg, config)
  end
  
  def wiki_page_info(page = nil)
    page ||= @page # By default take page from instance variable
    
    render :partial => "#{template_dir '_wiki_page_info'}/wiki_page_info", :locals => { :page => page }
  end
  
  def wiki_page_actions(page = nil)
    page ||= @page # By default take page from instance variable
    
    render :partial => "#{template_dir '_wiki_page_actions'}/wiki_page_actions", :locals => { :page => page }
  end
  
  def wiki_page_history(page = nil,versions = nil)
    page ||= @page # By default take page from instance variable
    versions ||= page.versions
    
    render :partial => "#{template_dir '_wiki_page_history'}/wiki_page_history", :locals => { :page => page, :versions => versions, :with_form => (versions.size > 1) }
  end
    
end