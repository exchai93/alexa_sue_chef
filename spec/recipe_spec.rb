require 'recipe'

RSpec.describe Recipe do
  let(:recipe_file) { JSON.parse(File.read('sample_json.rb')) }
  subject(:recipe) { described_class.new(recipe_file) }

  describe '#name' do
    it 'returns the recipe name if found' do
      expect(recipe.name).to eq "Baked Lemon Snapper"
    end
  end

  describe '#start_cooking_step' do
    it 'returns the first step of the recipe' do
      expect(recipe.start_cooking_step).to eq "Preheat oven to 390 °F (200 °C)."
    end
  end

  describe '#step' do
    it 'returns the instructions for the specified step' do
      expect(recipe.step(1)).to eq "Go fishing."
    end
  end
end
