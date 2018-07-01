class Planet < RedisOrm::Base

    DEFAULT_PRODUCTION = 10

    belongs_to :game
    belongs_to :player, :as => :owner
    belongs_to :cell

    property :id, Integer
    property :buff, Integer
    property :kill_perc, Integer
    property :production, Integer
    property :ships, Integer

    validates :buff, numericality: { only_integer: true }
    validates :kill_perc, presence: true, numericality: { less_than: 1, greater_than: 0 }
    validates :production, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :ships, presence: true, numericality: { only_integer: true }

end