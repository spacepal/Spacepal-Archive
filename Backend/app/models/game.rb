class GameValidator < ActiveModel::Validator
  
  def validate record
    self.piece_of_validations record, lambda { |r|
      r.planets_count <= ( r.width * r.height)
    }, "not enaugh cells for planets", record.planets_count, record.width, record.height
    self.piece_of_validations record, lambda { |r|
      r.players_limit <= ( r.width * r.height)
    }, "not enaugh cells for players", record.players_limit, record.width, record.height
    self.piece_of_validations record, lambda { |r|
      r.players_limit <= ( r.planets_count)
    }, "not enaugh planets for players", record.players_limit, record.planets_count
  end

  def piece_of_validations record, func, error_msg, *args
    if args.any? { |arg| arg.nil? }
      return
    else
      res = func.call record
      unless res
        record.errors[:base] << error_msg
      end
    end
  end

end

class Game < Ohm::Model

  include ActiveModel::Validations

  IS_ROOM = 0
  IS_OVER = -1
  FIRST_STEP = 1

  collection :planets, :Planet
  collection :players, :Player
  collection :cells, :Cell

  attribute :name 
  attribute :pin_code
  attribute :width, lambda { |x| x.to_i }
  attribute :height , lambda { |x| x.to_i }
  attribute :planets_count, lambda { |x| x.to_i }
  attribute :players_limit, lambda { |x| x.to_i }
  attribute :step, lambda { |x| x.to_i }
  attribute :accumulative, lambda { |x| x.to_bool }
  attribute :buffs, lambda { |x| x.to_bool }
  attribute :pirates, lambda { |x| x.to_bool }
  attribute :production_after_capture, lambda { |x| x.to_bool }
  attribute :notifications

  index :step

  validates_with GameValidator
  validates :name, presence: true, length: { :in => 1..32 }
  validates :pin_code, format: { with: /(|\d{4})/, message: "only digits allows" }, allow_nil: true
  validates :width, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 2 }
  validates :height, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 2}
  validates :planets_count, presence: true, numericality: { only_integer: true }
  validates :players_limit, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 8, greater_than_or_equal_to: 2  }
  validates :accumulative, inclusion: { in: [true, false, "true", "false"] }, allow_nil: true
  validates :buffs, inclusion: { in: [true, false, "true", "false"] }, allow_nil: true
  validates :pirates, inclusion: { in: [true, false, "true", "false"] }, allow_nil: true
  validates :production_after_capture, inclusion: { in: [true, false, "true", "false"] }, allow_nil: true

  def id
    super.to_i
  end

  def set_notifications _hash
    self.notifications = _hash.to_json
    self.save
  end

  def get_notifications
    if self.notifications
      JSON.parse self.notifications
    else
      nil
    end 
  end

  def clear_notifications
    self.notifications = {}
    self.players.each do |player|
      notifications[player.id] = []
    end
    self.notifications = self.notifications.to_json 
    self.save
  end

  def production_after_capture?
    self.production_after_capture == true
  end

  def accumulative?
    self.accumulative == true
  end

  def self.in_room_count
    arr = self.all.reduce (0) { |count, game| count = game.room? ? count += 1 : count }
  end

  def get_capital_planets
    arr = self.planets.map { |planet| planet if planet.is_capital }
    arr.compact
  end

  def make_planets_not_capitals
    self.get_capital_planets.each do |planet| 
      planet.is_capital = false
      unless planet.player
        planet.set_properties
      end
      planet.save
    end

  end

  def get_planets_to_players
    capitals = self.get_capital_planets
    d = capitals.count.to_f / self.players.count
    self.players.each_with_index do |player, index|
      n = (index * d).to_i
      capitals[n].player = player
      capitals[n].save
    end

  end

  def set_players_colors
    self.players.each_with_index do |player, index|
      player.color_id = index + 1
      player.save
    end
  end

  def get_state
    return 1 if self.room?
    return 2 if self.playing?
    return 3 if self.over?
  end

  def start_game
    self.step = Game::FIRST_STEP
    self.save
  end

  def over
    self.step = Game::IS_OVER
    self.save
  end

  def continue
    self.step += 1
    self.save
  end

  def room?
    self.step == Game::IS_ROOM
  end

  def playing?
    self.step != Game::IS_ROOM and self.step != Game::IS_OVER 
  end

  def width 
    self.attributes[:width].to_i
  end
  def height 
    self.attributes[:height].to_i
  end
  def planets_count 
    self.attributes[:planets_count].to_i
  end
  def players_limit 
    self.attributes[:players_limit].to_i
  end
  def step 
    self.attributes[:step].to_i
  end

  def shuffle_map
    self.planets.each { |planet| planet.cell_id = nil; planet.save }
    self.cells.each { |cell| cell.planet_id = nil; cell.save }
    cells_ids = self.cells.ids
    planets_ids = self.planets.ids
    cells_ids = cells_ids.shuffle.take self.planets_count
    cells_ids.each_with_index do  |cell_id, index|
      cell = self.cells[cell_id]
      planet = self.planets[planets_ids[index]]
      cell.planet = self.planets[index]
      cell.save
      planet.cell = cell
      planet.save
    end
  end

  def over?
    self.step == Game::IS_OVER
  end

  def self.get_all_in_room params #get hash of selected games
    params[:conditions] = { step: Game::IS_ROOM }
    start_num = params[:offset].to_i
    end_num = params[:offset].to_i + params[:limit].to_i
    arr = Game.find(step: Game::IS_ROOM).sort_by(:id, limit: [start_num, end_num])
    arr_hash = []
    el_hash = {}
    arr.each do |game|
      el_hash[:id] = game.id
      el_hash[:creator] = game.get_creator.name
      el_hash[:name] = game.name
      el_hash[:has_pin_code] = game.pin_code != nil 
      el_hash[:width] = game.width
      el_hash[:height] = game.height
      el_hash[:planets_count] = game.planets_count
      el_hash[:players_limit] = game.players_limit
      el_hash[:players_count] = game.players.count
      el_hash[:accumulative] = game.accumulative
      el_hash[:buffs] = game.buffs
      el_hash[:pirates] = game.pirates
      el_hash[:production_after_capture] = game.production_after_capture
      arr_hash.push el_hash.clone
    end
    arr_hash
  end

  def add_player player_name
    if self.players.size < self.players_limit
      if self.playername_is_uniq player_name
        pl = Creation.create_player player_name
        if pl.id
          pl.game = self
          pl.save
          pl
        end
      else
        self.errors.add :player_name, "the name is already used"
        nil
      end
    else
      self.errors.add :players_limit, "no place for new player"
      nil
    end
  end

  def add_player_bot ai_name
    if self.players.size < self.players_limit
      begin
      player_name = Faker::Name.first_name
      end until self.playername_is_uniq player_name
      pl = Creation.create_player player_name, is_ai: true, ai_name: ai_name
      if pl.id
        pl.game = self
        pl.save
        pl
      end
      nil
    else
      self.errors.add :players_limit, "no place for new player"
      nil
    end
  end

  def players_not_bot
    (self.players.map { |player| player unless player.ai? }).compact
  end

  def bots
    (self.players.map { |player| player if player.is_ai }).compact
  end

  def bots?
    return self.bots.count > 0
  end

  def remove_bot player_id
    if Player[player_id].ai?
      self.remove_player(player_id) 
    end
  end

  def remove_player player_id
    if self.room?
      if self.players_not_bot.count == 1 and !Player[player_id].ai?
        Deletion.delete_game self
        return nil
      else
        pl = Player[player_id]
        pl.game = nil
        pl.save
        pl.delete
        self.make_new_admin
        return self
      end
    end
    if self.playing?
      player = Player[player_id]
      player.surrender
      return self
    end
  end

  def make_new_admin
    self.players_not_bot.first.make_admin
  end

  def playername_is_uniq player_name
    !self.players.to_a.pluck_arr(:name).include? player_name
  end

  def get_creator
    self.players.each do |player| 
      if player.is_admin
        return player
      end
    end
    nil
  end
  
  def not_loosing_players
    (self.players.map { |player| player unless player.game_over? }).compact
  end

  def not_loosing_players_count
    self.not_loosing_players.count
  end

  def not_loose_not_bot_players_count
    (self.players.map { |player| player unless player.game_over? or player.ai? }).compact.count
  end

  def everybody_ends_turn?
    self.players.each { |player| return false unless player.end_turn? }
    return true
  end

  def self.ids_room
    (array = Game.all.map { |game| 
        game.id if game.room? and game.pin_code.nil? 
      }).compact
  end

  def planets_info
    self.planets.map do |planet|
      {
        "id"=> planet.id.to_i,
        "ownerID"=> planet.player_id.to_i,
        "cellID"=> planet.cell.relative_id.to_i,
        "production"=> planet.production.to_i,
        "killPerc"=> planet.kill_perc.to_f,
        "ships"=> planet.ships.to_i
      }
    end
  end

  def map_size
    {
      "width" => self.width.to_i,
      "height" => self.height.to_i
    }
  end

  def update hash
    obj = Game.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def self.create hash
    obj = Game.new hash
    if obj.valid?
      super hash
      true
    else
      false
    end
  end

  def save
    if self.valid?
      super
      true
    else
      false
    end
  end


end