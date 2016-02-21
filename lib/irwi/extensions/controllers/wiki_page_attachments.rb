module Irwi::Extensions::Controllers::WikiPageAttachments
  def add_attachment
    attachment = page_attachment_class.new(permitted_page_attachment_params)
    attachment.save!
    redirect_to url_for(path: attachment.page.path, action: :edit)
  end

  def remove_attachment
    attachment = page_attachment_class.find(params[:attachment_id])
    attachment.destroy
    redirect_to url_for(path: attachment.page.path, action: :edit)
  end

  private

  def page_attachment_class
    Irwi.config.page_attachment_class
  end

  def permitted_page_attachment_params
    params.require(:wiki_page_attachment).permit(:page_id, :wiki_page_attachment)
  end
end
