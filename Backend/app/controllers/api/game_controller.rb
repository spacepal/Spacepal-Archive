class Api::GameController < ApplicationController
  def index
    arr = Game.all :offset => params[:offset], :limit => params[:limit]
    render :json => { games: arr }
  end

  def create
    
  end

end
