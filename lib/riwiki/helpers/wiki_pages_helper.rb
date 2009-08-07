module Riwiki::Helpers::WikiPagesHelper
  
  # Edit form for wiki page model
  def wiki_page_form( options = {}, &block )
    form_for( :page, @page, { :url => url_for( :action => :update ) }.merge!( options ), &block )
  end
  
  def wiki_page_edit_path
    url_for( :action => :edit )
  end
  
  def wiki_page_path
    url_for( :action => :show )
  end
  
end