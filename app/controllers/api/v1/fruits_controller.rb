module OurTextHelper
  def pluralize_upcase(singular)
    the_thing = singular.to_s.upcase
    return the_thing if the_thing == "FRUIT" || the_thing == "SPORT" # It should be SPORT bar not SPORTS bar
    the_thing.pluralize(2).upcase
  end
end

class Api::V1::FruitsController < ApplicationController
  include OurTextHelper

  def index
    fruits = Fruit.find_by_sql( "select UPPER(classification) as classification, id, name, description from fruits order by classification" )
    items = []
    classifications = []

# This is to make it show classification (e.g. CAR) only once, at the top of the items - see render() in _fruit.js.jsx
    fruits.each do |fruit|
      item = {id: fruit.id, category: pluralize_upcase(fruit.classification), classification: fruit.classification, name: fruit.name, description: fruit.description}
      if classifications.include? fruit.classification
        item[:category] = ""
      else
        classifications << fruit.classification
      end
      items << item
    end

    render json: items
  end

  def create
    fruit = Fruit.create(fruit_params)
    render json: fruit
  end

  def destroy
    Fruit.destroy(params[:id])
  end

  def update
    fruit = Fruit.find(params[:id])
    fruit.update_attributes(fruit_params)
    render json: fruit
  end

  private

  def fruit_params
    params.require(:fruit).permit(:id, :name, :description, :classification)
  end
end
