require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships/validations' do

    it { should have_many :items }
    it { should validate_presence_of :name }

    it 'validates default disabled status' do
      merchant = create(:merchant)
      expect(merchant.status).to eq("disabled")
    end
  end

  describe 'class methods/scopes' do
    describe 'by status' do
      before :each do
        @merch1 = create :merchant, { status: 'enabled'}
        @merch2 = create :merchant
        @merch3 = create :merchant, { status: 'enabled'}
        @merch4 = create :merchant
      end

      it 'has disabled' do
        expect(Merchant.by_status('disabled')).to eq([@merch2, @merch4])
      end

      it 'has enabled' do
        expect(Merchant.by_status('enabled')).to eq([@merch1, @merch3])
      end
    end
  end 
end
