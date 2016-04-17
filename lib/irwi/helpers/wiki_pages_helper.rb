module Irwi::Helpers::WikiPagesHelper
  include Irwi::Support::TemplateFinder
  include Irwi::Helpers::WikiPageAttachmentsHelper

  # Edit form for wiki page model
  def wiki_page_form(config = {}, &block)
    form_for(@page, { as: :page, url: url_for(action: :update), html: { class: 'wiki_form', method: :post } }.merge!(config), &block)
  end

  def wiki_page_new_path
    page = CGI.escape(params[:path]) if params && params[:path].present?
    wiki_page_path(page, :new)
  end

  def wiki_page_edit_path(page = nil)
    wiki_page_path(page, :edit)
  end

  def wiki_page_history_path(page = nil)
    wiki_page_path(page, :history)
  end

  def wiki_page_compare_path(page = nil)
    wiki_page_path(page, :compare)
  end

  def wiki_page_path(page = nil, action = :show)
    if page
      page = page.path if page.respond_to? :path
      page = nil if page.empty?

      url_for(action: action, path: page)
    else
      url_for(action: action)
    end
  end

  def wiki_content(text)
    sanitize(auto_link(Irwi.config.formatter.format(wiki_linkify(wiki_show_attachments(text))).html_safe))
  end

  def wiki_diff(old_text, new_text)
    Irwi.config.comparator.render_changes(h(old_text), h(new_text)).html_safe
  end

  def wiki_user(user)
    return ("&lt;" + wt("Unknown") + "&gt;").html_safe unless user

    if user.respond_to?(:name)
      user.name
    else
      "User##{user.id}"
    end
  end

  IRWI_LINK_REGEXP =
    /\[\[
      (?:([^\[\]\|]+)\|)?
      ([^\[\]]+)
     \]\]
     (\w+)?/xu

  def wiki_linkify(str)
    str.gsub IRWI_LINK_REGEXP do |_m|
      text = "#{Regexp.last_match(2)}#{Regexp.last_match(3)}"
      link, anchor = Regexp.last_match(1) ? Regexp.last_match(1).split('#', 2) : Regexp.last_match(2)

      "<a href=\"#{wiki_link link}#{'#' + anchor if anchor}\">#{text}</a>"
    end.html_safe
  end

  def wiki_paginate(collection, &block)
    Irwi.config.paginator.paginated_section(self, collection, &block)
  end

  def wiki_link(title)
    page = Irwi.config.page_class.find_by_title(title)
    path = page ? page.path : CGI.escape(title)

    url_for(controller: Irwi.config.controller_name, action: :show, path: path)
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
    render partial: "#{template_dir '_wiki_page_style'}/wiki_page_style"
  end

  def wiki_page_info(page = nil)
    page ||= @page # By default take page from instance variable

    render partial: "#{template_dir '_wiki_page_info'}/wiki_page_info", locals: { page: page }
  end

  def wiki_page_actions(page = nil)
    page ||= @page # By default take page from instance variable

    render partial: "#{template_dir '_wiki_page_actions'}/wiki_page_actions", locals: { page: page }
  end

  def wiki_page_history(page = nil, versions = nil)
    page ||= @page # By default take page from instance variable
    versions ||= @versions || page.versions

    render partial: "#{template_dir '_wiki_page_history'}/wiki_page_history", locals: { page: page, versions: versions, with_form: (versions.size > 1) }
  end

  def wiki_page_attachments(page = @page)
    return unless Irwi.config.page_attachment_class_name

    render partial: "#{template_dir '_wiki_page_actions'}/wiki_page_attachments", locals: { page: page }
  end
end
