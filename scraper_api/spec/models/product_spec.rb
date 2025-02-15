# spec/models/product_spec.rb
require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { create(:product) }
  describe 'validations' do
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url) }
  end
 
  describe '#needs_update?' do
    let(:product) { create(:product) }
    
    context 'when never scraped' do
      it 'returns true' do
        expect(product.needs_update?).to be true
      end
    end
    
    context 'when recently scraped' do
      before { product.update(last_scraped_at: 1.day.ago) }
      
      it 'returns false' do
        expect(product.needs_update?).to be false
      end
    end
  end
end

