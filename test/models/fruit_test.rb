require 'test_helper'

class FruitTest < ActiveSupport::TestCase
  test "fruit" do
    fruits = [{ name: "Grapefruit", description: "Like an orange but bigger", classification: "FRUIT" },
              { name: "Ford Focus", description: "Like a Ferrari but smaller", classification: "CAR" }]

    fruits.each do |attributes|
      fruit = Fruit.new attributes
      fruit.save!
    end
  end
end
