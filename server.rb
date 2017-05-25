require 'sinatra/base'
require 'json'
require_relative './lib/alexa/request'
require_relative './lib/alexa/response'
require_relative './lib/recipe'

class AlexaChef < Sinatra::Base
  enable :sessions
  FatSecret.init(ENV["FATSECRET_KEY"],ENV["FATSECRET_SECRET"])

  post '/' do
    alexa_request = Alexa::Request.new(request)


    if alexa_request.intent_name == "FindRecipe"
      return respond_with_recipe_name(alexa_request)
    end

    if alexa_request.intent_name == 'Ingredients'
      recipe_name = alexa_request.session_attribute("recipeName")
      read = alexa_request.slot_value("Read")
      recipe = JSON.parse(File.read("sample_json.rb"))

      if alexa_request.slot_value("Read") == "read ingredients"
        recipe_ingredients = recipe['recipe']['ingredients']['ingredient']['ingredient_description']
        response_text = "Here are the ingredients: " + recipe_ingredients
      end

      return Alexa::Response.build(response_text: response_text, session_attributes: { recipeName: recipe_name} )
    end

    if alexa_request.intent_name == 'Steps'
      return respond_with_steps(alexa_request)
    end
  end

  def respond_with_recipe_name(alexa_request)
    # recipe = Recipe.find(alexa_request.slot_value("Recipe"))
    recipe = Recipe.find(91)
    p recipe.class
    response_text = "Found " + recipe.name
    return Alexa::Response.build(response_text: response_text, session_attributes: { recipeName: recipe.recipe.to_json })
  end

  def respond_with_steps(alexa_request)
    p JSON.parse(alexa_request.session_attribute('recipeName')).class
    # recipe_name = alexa_request.session_attribute("recipeName")
    # recipe = Recipe.find(alexa_request.session_attribute("Recipe"))
    p alexa_request.session_attribute("recipeName")
    # recipe = alexa_request.session_attribute("recipeName").recipe
    # action = alexa_request.slot_value("Action")
    # recipe = JSON.parse(File.read("sample_json.rb"))

    response_text = recipe.start_cooking_step if alexa_request.slot_value("Action") == 'start cooking'
    # response_text = recipe.step(***) if alexa_request.slot_value("Action") == 'next'
    # response_text = recipe.step(***) if alexa_request.slot_value("Action") == 'repeat'

    if action == 'start cooking'
      response_text = recipe['recipe']['directions']['direction'][stepNumber]['direction_description']
      stepNumber += 1
    end

    if action == 'repeat'
      stepNumber -= 1
      response_text = recipe['recipe']['directions']['direction'][stepNumber]['direction_description']
      stepNumber += 1
    end

    if action == 'next'
      # step = recipe['recipe']['directions'].keys[stepNumber]
      response_text = recipe['recipe']['directions']['direction'][stepNumber]['direction_description']
      stepNumber += 1
    end
    return Alexa::Response.build(response_text: response_text, session_attributes: { recipeName: recipe_name, stepNumber: stepNumber })
  end
end
