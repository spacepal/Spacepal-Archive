class Api::GameController < ApplicationController

  def index
    arr = Game.get_all_in_room :offset => params[:offset], :limit => params[:limit]
    render :json => { games: arr, :count => Game.in_room_count }
  end

  def create
    data = game_params
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
    if params[:id] == "random"
      game_id = Game.ids_room.sample
    else
      game_id ||= params[:id].to_i
    end
    data = game_params
    game = Game[game_id]
    unless game
      render :json => { errors: ["can't find the game"] }
      return
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
        render :json => { errors: nil, gameID: game_id.to_i }
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
    "leave".color(:blue).bg(:white).out
    game_id = cookies.encrypted[:game_id]
    player_id = cookies.encrypted[:player_id]
    cookies.delete :game_id
    cookies.delete :player_id
    game = Game[game_id]
    if game
      game = game.remove_player player_id
      core = Core.new game_id, player_id
      if game&.playing?
        core.end_turn([])
        #core.check_game_on_leaving
      end
      if game and game&.room?
        core.broadcast_player game.get_creator.id
        core.broadcast_players
        core.broadcast_planets
        core.broadcast_game
      end
      render :json => { errors: [ nil ]}
    else
      render :json => { errors: [ "Game\##{game_id} does not exist" ]}
    end
  end

  def create_bot_fleets
    "create_bot_fleets".bg(:green).color(:black).out
    game_id = params[:game_id]
    game = Game[game_id]
    if game.step.to_i <= params[:step_id].to_i
      core = Core.new game_id, nil
      core.bot_make_turn bot_fleets_params
    end
    render 200
  end

  def check_status
    render ""
  end

private

  def game_params
    params.require(:data).permit!
  end

  def bot_fleets_params
    params.require(:tasks).map { |task| task.to_unsafe_hash.to_h }
  end

end
