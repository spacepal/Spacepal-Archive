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
      if !res
        record.errors[:base] << error_msg
      end
    end
  end

end

class Game < Ohm::Model

  include ActiveModel::Validations

  IS_ROOM = 0
  IS_OVER = -1

  collection :fleets, :Fleet
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
  attribute :accumulative 
  attribute :buffs 
  attribute :pirates 
  attribute :production_after_capture 

  index :step

  validates_with GameValidator
  validates :name, presence: true, length: { :in => 1..32 }
  validates :pin_code, format: { with: /(|\d{4})/, message: "only digits allows" }, allow_nil: true
  validates :width, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 2 }
  validates :height, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 64, greater_than_or_equal_to: 2}
  validates :planets_count, presence: true, numericality: { only_integer: true }
  validates :players_limit, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 8, greater_than_or_equal_to: 2  }
  validates :accumulative, inclusion: { in: [true, false, "true", "false"] }
  validates :buffs, inclusion: { in: [true, false, "true", "false"] }
  validates :pirates, inclusion: { in: [true, false, "true", "false"] }
  validates :production_after_capture, inclusion: { in: [true, false, "true", "false"] }

  def is_room?
    self.step == Game::IS_ROOM
  end

  def is_playing?
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

  def get_map

  end

  def shuffle_map
    self.planets.each { |planet| planet.cell_id = nil }
    self.cells.each { |cell| cell.planet_id = nil }
    cells_ids = self.cells.ids
    cells_ids = cells_ids.shuffle.take game.planets_count
    cells_ids.each_with_index do  |cell_id, index|
      self.cells[cell_id].planet = self.planets[index]
      self.cells[cell_id].save
    end
    self.get_map
  end

  def is_over?
    self.step == Game::IS_OVER
  end

  def self.get_all params #get hash of selected games
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
      el_hash[:has_pin_code] = game.pin_code != ""
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
          self.players << pl
          true
        end
      else
        self.errors.add :player_name, "the name is already used"
        false
      end
    else
      self.errors.add :players_limit, "no place for new player"
      false
    end
  end

  def remove_player player_id
    if self.players.size == 1
      Deletion.delete_game self
      return nil
    else
      self.players.delete Player[player_id]
      self
    end
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