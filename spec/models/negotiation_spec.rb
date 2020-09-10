require 'rails_helper'

RSpec.describe Negotiation, type: :model do
  it 'Date of start and seller id automatically fills in' do
    user = Collaborator.create(email: 'user@email.com', password: '123456')
    another_user = Collaborator.create(email: 'another@email.com', password: '123456')
    category = ProductCategory.create(name: 'Category')
    product = Product.create(name: 'N', description: 'D', sale_price: 10,
                             product_category: category, collaborator: user)
    negotiation = Negotiation.create(product: product, collaborator: another_user)

    expect(negotiation.date_of_start).to be_present
    expect(negotiation.seller_id).to be_present
    expect(negotiation.seller_id).to eq user.id
  end
end
