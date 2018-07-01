desc "Fill in database"
namespace :db do
  task :seed_game => :environment do
    Game.all.each { |game| game.destroy }
    100.times do |n| 
      game = Game.new
      game.name = "game " + n.to_s
      game.width = 10
      game.height = 10
      game.planets_count = 50
      game.players_limit = 8
      game.accumulative = [true, false][Random.new.rand.round]
      game.buffs = [true, false][Random.new.rand.round]
      game.pirates = [true, false][Random.new.rand.round]
      game.production_after_capture = [true, false][Random.new.rand.round]
      game.save
    end
  end
end