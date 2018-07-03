require "rails_helper"

RSpec.describe Cell, type: :model do
  it "saves with valid props" do 
    cell = Cell.new
    cell.coord_x = 10
    cell.coord_y = 10
    expect(cell).to be_valid
  end  
  it "not saves with invalid props" do
    cell = Cell.new
    cell.coord_x = 65
    cell.coord_y = 0
    expect(cell).to_not be_valid
  end
  
end