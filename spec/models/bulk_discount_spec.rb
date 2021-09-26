require 'rails_helper'
# rspec spec/models/bulk_discount_spec.rb
RSpec.describe BulkDiscount, type: :model do
  describe 'relationships/validations' do
    it { should belong_to :merchant }
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
