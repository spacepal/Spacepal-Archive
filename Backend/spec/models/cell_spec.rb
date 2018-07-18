require "rails_helper"

RSpec.describe Cell, type: :model do
  it "saves with valid props" do 
    cell = Cell.new
    cell.x = 10
    cell.y = 10
    valid = cell.valid?
    expect(valid).to be true
  end  
  it "not saves with invalid props" do
    cell = Cell.new
    cell.x = 65
    cell.y = 0
    valid = cell.valid?
    expect(valid).to be false
  end
end