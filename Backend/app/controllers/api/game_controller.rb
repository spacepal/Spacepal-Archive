class Api::GameController < ApplicationController

  def index
    arr = Game.get_all :offset => params[:offset], :limit => params[:limit]
    render :json => { games: arr, :count => Game.all.count }
  end

  def create
    data = self.game_params
    player = Creation.create_player data[:username]
    unless player.errors.empty?
      render :json => { errors: player.errors.messages.flatten }
      return
    end
    flags = {}
    flags[:has_pin_code] = data[:flags][:hasPinCode]
    flags[:buffs] = data[:flags][:buffs]
    flags[:production_after_capture] = data[:flags][:productionAfterCapture]
    flags[:pirates] = data[:flags][:pirates]
    flags[:accumulative] = data[:flags][:accumulative]
    game = Creation.create_game player, data[:gamename],
      data[:map], data[:playersLimit], data[:planetsCount],
      data[:pinCode], flags
    if game.errors.empty?
      Creation.create_cells game
      Creation.create_planets game
      cookies.encrypted[:player_id] = player.id
      cookies.encrypted[:game_id] = game.id
      render :json => { errors: nil, gameID: game.id }
      return
    else
      render :json => { errors: game.errors.messages.flatten }
      return
    end
  end

  def join
    game_id = params[:id].to_i
    data = self.game_params
    game = Game[game_id]
    unless game
      render :json => { errors: ["can't find game with id " + game.id.to_s] }
    end
    if game.room?
      if game.pin_code
        unless data[:pinCode] == game.pin_code
          render :json => { errors: ["the pin code is wrong"] }
          return
        end
      end
      player = game.add_player data[:username]
      if player
        cookies.encrypted[:player_id] = player.id
        cookies.encrypted[:game_id] = game.id
        render :json => { errors: nil }
        return
      else
        render :json => { errors: game.errors.messages.flatten }
        return
      end
    else
      render :json => { errors: ["the game was started"]}
      return
    end
  end

  def leave
    game_id = cookies.encrypted[:game_id]
    player_id = cookies.encrypted[:player_id]
    cookies.delete :game_id
    cookies.delete :player_id
    game = Game[game_id]
    if game
      core = Core.new
      game = game.remove_player player_id
      if game.playing?
        core.end_turn(Player[player_id], [])
      end
      if game
        core.broadcast_player game.get_creator.id
        core.broadcast_players game.id
        core.broadcast_planets game.id
        core.broadcast_game game.id
      end
      render :json => { errors: [ nil ]}
    else
      render :json => { errors: [ "Game\##{game_id} does not exist" ]}
    end
  end

  def game_params
    params.require(:data).permit!
  end

end
