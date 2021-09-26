require 'rails_helper'
# rspec spec/models/bulk_discount_spec.rb
RSpec.describe BulkDiscount, type: :model do
  describe 'relationships/validations' do
    it { should belong_to :merchant }

    it { should validate_numericality_of :quantity }
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }

    it { should validate_numericality_of :percentage }
    it { should validate_numericality_of(:percentage).is_less_than_or_equal_to(100) }
    it { should validate_numericality_of(:percentage).is_greater_than_or_equal_to(0) }
  end

  describe 'class methods/scopes' do
    describe 'class method name' do
      before :each do
      end
      it 'does what the method says' do
      end
    end
  end
end
