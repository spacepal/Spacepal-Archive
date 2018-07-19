require "rails_helper"

RSpec.describe Fleet, type: :model do
  it "not saves with invalid props" do
  fleet = Fleet.new
    fleet.kill_perc = 0
    #fleet.status = "Fleet::DEFAULT_STATUS"
    fleet.ships = -9
    fleet.planet_from_id = 0
    fleet.planet_to_id = 0
    fleet.steps_left = 0
    expect(fleet).to_not be_valid
  end

=begin
  it "saves with valid props" do
    fleet = Fleet.new
    fleet.kill_perc = 0.5
    #fleet.status = Fleet::DEFAULT_STATUS
    fleet.ships = 100
    fleet.planet_from_id = 5
    fleet.planet_to_id = 10
    fleet.steps_left = 3
    fleet.started = false
    fleet.valid?
    #fleet.errors.messages.to_s.color(:red).out
    expect(fleet).to be_valid
  end
  it "makes aggressive" do 
    fleet = Fleet.new
    fleet.kill_perc = 0.5
    fleet.started = false
    fleet.make_aggressive
    fleet.ships = 100
    expect(fleet.status).to eq "aggressive"
  end
  it "makes deffensive" do 
    fleet = Fleet.new
    fleet.kill_perc = 0.5
    fleet.make_deffensive
    fleet.ships = 100
    expect(fleet.status).to eq "deffensive"
  end
  it "makes avoiding" do 
    fleet = Fleet.new
    fleet.kill_perc = 0.5
    fleet.make_avoiding
    fleet.ships = 100
    expect(fleet.status).to eq "avoiding"
  end
=end

end