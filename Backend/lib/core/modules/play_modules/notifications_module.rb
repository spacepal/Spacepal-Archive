module NotificationModule

  def add_notification type: nil, player_id1: nil, _object_id: nil, player_id2: nil, fleet_data: nil
    "           notifications: add".bg(:white).color(:black).out
    case type
    when 1
      pirates_planet player_id1, _object_id
    when 2
      pirates_fleet player_id1, fleet_data
    when 3
      fleet_land player_id1, fleet_data
    when 4
      fleet_conquer player_id1, _object_id, player_id2
    when 5
      fleet_failed player_id1, _object_id, player_id2
    when 6
      player_lost player_id1
    else
      nil
    end
  end

  def execute_notifications
    "execute_notifications".bg(:magenta).color(:cyan).out
    Game[@game_id].set_notifications @notifications
  end

  def clear_notifications
    Game[@game_id].clear_notifications
  end

private

  def pirates_planet player_id, planet_id
    nots = {
      "type" => "PIRATES_DAMAGED_PLANET",
      "target" => planet_id,
      "player_id" => player_id
    }
    @notifications[player_id] << nots if @notifications and @notifications[player_id]
  end

  def pirates_fleet player_id, fleet_data
    nots = {
      "type" => "PIRATES_DAMAGED_FLEET",
      "fleet" => fleet_data,
      "member" => player_id
    }
    @notifications[player_id] << nots if @notifications and @notifications[player_id]
  end

  def fleet_land player_id, fleet_data
    nots = {
      "type" => "FLEET_LAND",
      "fleet" => fleet_data,
      "member" => player_id
    }
    @notifications[player_id] << nots if @notifications and @notifications[player_id]
  end

  def fleet_conquer player_id1, planet_id, player_id2
    unless Player[player_id1].ai?
      nots = {
        "type" => "ATTACK_SUCCESS",
        "target" => planet_id,
        "member" => player_id2
      }
      @notifications[player_id1] << nots if @notifications and @notifications[player_id1]
    end
    unless player_id2.to_i == -1 or Player[player_id2]&.ai?
      nots = {
        "type" => "PLANET_LOST",
        "target" => planet_id,
        "member" => player_id1
      }
      @notifications[player_id2] << nots if @notifications and @notifications[player_id2]
    end
  end

  def fleet_failed player_id1, planet_id, player_id2
    unless Player[player_id1].ai?
      nots = {
        "type" => "ATTACK_FAILED",
        "target" => planet_id,
        "member" => player_id2
      }
      @notifications[player_id1] << nots if @notifications and @notifications[player_id1]
    end
    unless player_id2.to_i == -1  or Player[player_id2]&.ai?
      nots = {
        "type" => "PLANET_SAVED",
        "target" => planet_id,
        "member" => player_id1
      }
      @notifications[player_id2] << nots if @notifications and @notifications[player_id2]
    end
  end

  def player_lost player_id
    nots = {
      "type" => "PLAYER_LOST",
      "target" => nil,
      "member" => player_id
    }
    Game[@game_id].players.each do |player|
      unless player.id == player_id or player&.ai?
        @notifications[player.id] << nots if @notifications and @notifications[player.id]
      end 
    end
  end

end