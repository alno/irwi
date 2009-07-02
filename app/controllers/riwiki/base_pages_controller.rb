class Riwiki::BasePagesController < ApplicationController
  
  def show
    render :text => params[:page].to_s
  end
  
end