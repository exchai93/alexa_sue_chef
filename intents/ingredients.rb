require './lib/recipe'

intent "Ingredients" do
  recipe = Recipe.new(request.session_attribute('recipe'))
  method = request.slot_value('Ingredients')

  if method =~ /[iI]ngredient/
    respond(response_text: "Would you like to hear the ingredients one at a time or altogether? If you choose the former, say next to hear the next ingredient.", session_attributes: { recipe: recipe.content })
  elsif method =~ /one || next/
    ingredient_number = request.session_attribute('ingredient_number') || 0
    ingredient = recipe.ingredinets[ingredient_number]
    ingredient_number == recipe.ingredients.count - 1 ? response_text = "The last ingredient is #{ingredient}" : response_text = ingredient
    respond(response_text: ingredient, session_attribute: { recipe: recipe.contents, ingredient_number: ingredient_number})
  else
    response_text = "Here are the ingredients: " + recipe.ingredients.join(', ')
    respond(response_text: response_text, session_attributes: { recipe: recipe.contents })
  end
end
