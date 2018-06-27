class Planet < RedisOrm::Base

    belongs_to :game
    belongs_to :player, :as => :owner
    belongs_to :cell

    property :id, Integer
    property :buff, Integer
    property :kill_perc, Integer
    property :production, Integer
    property :ships, Integer

end