require "rails_helper"

RSpec.describe Cell, type: :model do
  it "saves with valid props" do 
    cell = Cell.new
    cell.coord_x = 10
    cell.coord_y = 10
    valid = cell.valid?
    expect(valid).to be true
  end  
  it "not saves with invalid props" do
    cell = Cell.new
    cell.coord_x = 65
    cell.coord_y = 0
    valid = cell.valid?
    expect(valid).to be false
  end
  
end