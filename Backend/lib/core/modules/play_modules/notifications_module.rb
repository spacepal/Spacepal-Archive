module NotificationModule

  def add_notification type: nil, player_id1: nil, _object_id: nil, player_id2: nil
    "           notifications: add".bg(:white).color(:black).out
    "type: #{type}, player_id1: #{player_id1}, _object_id: #{_object_id}, player_id2: #{player_id2}".bg(:white).color(:black).out
    case type
    when 1
      p "an1"
      pirates_planet player_id1, _object_id
      p "an2"
    when 2
      p "an3"
      pirates_fleet player_id1, _object_id
      p "an4"
    when 3
      p "an5"
      fleet_land player_id1, _object_id
      p "an6"
    when 4
      p "an7"
      fleet_conquer player_id1, _object_id, player_id2
      p "an8"
    when 5
      p "an9"
      fleet_failed player_id1, _object_id, player_id2
      p "an10"
    when 6
      p "an11"
      player_lost player_id1
      p "an12"
    else
      p "an13"
      nil
      p "an14"
    end
    "@notifications = #{@notifications}".out
    p "an15"
  end

  def execute_notifications
    "execute_notifications".bg(:magenta).color(:cyan).out
    "game.notifications: #{Game[@game_id].get_notifications}".color(:cyan).out
    Game[@game_id].set_notifications @notifications
    "game.notifications: #{Game[@game_id].get_notifications}".color(:cyan).out
  end

  def clear_notifications
    "clear_notifications".bg(:magenta).color(:cyan).out
    p Game[@game_id]
    p Game[@game_id].get_notifications
    p @notifications
    "game.notifications: #{Game[@game_id].get_notifications}".color(:cyan).out
    Game[@game_id].clear_notifications
    "game.notifications: #{Game[@game_id].get_notifications}".color(:cyan).out
  end

private

  def pirates_planet player_id, planet_id
    nots = {
      "type" => "PIRATES_DAMAGED_PLANET",
      "target" => planet_id,
      "player_id" => player_id
    }
    @notifications[player_id] << nots 
  end

  def pirates_fleet player_id, fleet_id
    nots = {
      "type" => "PIRATES_DAMAGED_FLEET",
      "target" => fleet_id,
      "member" => player_id
    }
    @notifications[player_id] << nots 
  end

  def fleet_land player_id, planet_id
    nots = {
      "type" => "FLEET_LAND",
      "target" => planet_id,
      "member" => player_id
    }
    @notifications[player_id] << nots 
  end

  def fleet_conquer player_id1, planet_id, player_id2
    p "fleet_conquer"
    nots = {
      "type" => "ATTACK_SUCCESS",
      "target" => planet_id,
      "member" => player_id2
    }
    p "fc1"
    @notifications[player_id1] << nots
    p "fc2"
    p player_id2
    unless player_id2.to_i == -1
      p "fc3"
      nots = {
        "type" => "PLANET_LOST",
        "target" => planet_id,
        "member" => player_id1
      }
      p "fc4"
      @notifications[player_id2] << nots
      p "fc5"
    end
  end

  def fleet_failed player_id1, planet_id, player_id2
    p "fleet_failed"
    nots = {
      "type" => "ATTACK_FAILED",
      "target" => planet_id,
      "member" => player_id2
    }
    p "ff1"
    @notifications[player_id1] << nots
    p "ff2"
    p player_id2
    unless player_id2.to_i == -1
      p "ff3"
      nots = {
        "type" => "PLANET_SAVED",
        "target" => planet_id,
        "member" => player_id1
      }
      p "ff4"
      @notifications[player_id2] << nots
      p "ff5"
    end
    p "ff6"
  end

  def player_lost player_id
    nots = {
      "type" => "PLAYER_LOST",
      "target" => nil,
      "member" => player_id
    }
    Game[@game_id].players.each do |player|
      unless player.id == player_id
        @notifications[player.id] << nots
      end 
    end
  end

end