module Riwiki::Extensions::WikiPagesControllerExtension

  def show
    render :text => params[:page].to_s
  end
  
  def edit
    render :text => "Editing " + params[:page].to_s + "<form action='#{params[:root]}/#{params[:page].join('/')}' method='POST'><input type='submit' /></form>"
  end
  
  def update
    render :text => "Updated " + params[:page].to_s
  end
  
end