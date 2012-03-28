module Irwi::Helpers::WikiPagesHelper

  include Irwi::Support::TemplateFinder
  include Irwi::Helpers::WikiPageAttachmentsHelper

  # Edit form for wiki page model
  def wiki_page_form( config = {}, &block )
    form_for( @page, { :as => :page, :url => url_for( :action => :update ), :html=> { :class => 'wiki_form', :method => :post } }.merge!( config ), &block )
  end

  def wiki_page_new_path
    if params && params[:path].present?
      page = CGI::escape(params[:path])
    end
    wiki_page_path( page, :new )
  end

  def wiki_page_edit_path( page = nil )
    wiki_page_path( page, :edit )
  end

  def wiki_page_history_path( page = nil )
    wiki_page_path( page, :history )
  end

  def wiki_page_compare_path( page = nil )
    wiki_page_path( page, :compare )
  end

  def wiki_page_path( page = nil, action = :show )
    if page
      page = page.path if page.respond_to? :path
      page = nil if page.empty?

      url_for( :action => action, :path => page )
    else
      url_for( :action => action )
    end
  end

  def wiki_content( text )
    sanitize( auto_link( Irwi.config.formatter.format( wiki_linkify( wiki_show_attachments(text) ) ) ) )
  end

  def wiki_diff( old_text, new_text )
    Irwi.config.comparator.render_changes(h(old_text), h(new_text)).html_safe
  end

  def wiki_user( user )
    return ("&lt;" + wt("Unknown") + "&gt;").html_safe unless user

    if user.respond_to?(:name)
      user.name
    else
      "User##{user.id}"
    end
  end

  def wiki_linkify( str )
    str.gsub /\[\[
                (?:([^\[\]\|]+)\|)?
                ([^\[\]]+)
               \]\]
               (\w+)?/xu do |m|
      text = "#$2#$3"
      link, anchor = if $1 then $1.split('#', 2) else $2 end
      "<a href=\"#{wiki_link link}#{ '#' + anchor if anchor}\">#{text}</a>"
    end.html_safe
  end

  def wiki_paginate( collection, &block )
    Irwi.config.paginator.paginated_section( self, collection, &block )
  end

  def wiki_link( title )
    if page = Irwi.config.page_class.find_by_title( title )
      url_for( :controller => Irwi.config.controller_name, :action => :show, :path => page.path )
    else
      url_for( :controller => Irwi.config.controller_name, :action => :show, :path => CGI::escape(title) )
    end
  end

  ##
  # Instead of having to translate strings and defining a default value:
  #
  #     t("Hello World!", :default => 'Hello World!')
  #
  # We define this method to define the value only once:
  #
  #     wt("Hello World!")
  #
  # Note that interpolation still works ...
  #
  #     wt("Hello {{world}}!", :world => @world)
  #
  def wt(msg, *args)
    config = args.extract_options!
    config[:default] = msg if config[:default].blank?
    config[:scope] = 'wiki'
    I18n.t(msg, config)
  end

  def wiki_page_style
    render :partial => "#{template_dir '_wiki_page_style'}/wiki_page_style"
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
    versions ||= @versions || page.versions

    render :partial => "#{template_dir '_wiki_page_history'}/wiki_page_history", :locals => { :page => page, :versions => versions, :with_form => (versions.size > 1) }
  end

  def wiki_page_attachments(page = @page)
    return unless Irwi::config.page_attachment_class_name

    page.attachments.each do |attachment|
      concat image_tag(attachment.wiki_page_attachment.url(:thumb))
      concat "Attachment_#{attachment.id}"
      concat link_to(wt('Remove'), wiki_remove_page_attachment_path(attachment.id), :method => :delete)
    end

    form_for(Irwi.config.page_attachment_class.new,
             :as => :wiki_page_attachment,
             :url => wiki_add_page_attachment_path(page),
             :html => { :multipart => true }) do |form|
      concat form.file_field :wiki_page_attachment
      concat form.hidden_field :page_id, :value => page.id
      concat form.submit 'Add Attachment'
    end
  end

end
