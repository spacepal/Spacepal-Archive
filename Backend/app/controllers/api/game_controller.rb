class Api::GameController < ApplicationController
  def index
    arr = Game.all :offset => params[:offset], :limit => params[:limit]
    render :json => { games: arr, :count => $redis.zcard("game:ids") }
  end

  def create
    
  end

end
