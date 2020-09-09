require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'Name, description, sale price and product category must be present' do
    product = Product.new

    product.valid?

    expect(product.errors[:collaborator]).to include('não pode ficar em branco')
    expect(product.errors[:collaborator]).to include('é obrigatório(a)')
    expect(product.errors[:product_category]).to include('não pode ficar em branco')
    expect(product.errors[:product_category]).to include('é obrigatório(a)')
    expect(product.errors[:name]).to include('não pode ficar em branco')
    expect(product.errors[:description]).to include('não pode ficar em branco')
    expect(product.errors[:sale_price]).to include('não pode ficar em branco')
    expect(product.errors[:sale_price]).to include('não é um número')
    expect(product.errors.count).to eq 8
  end

  it 'Sale price must be not negative' do
    product = Product.new

    product.sale_price = -1
    product.valid?

    expect(product.errors[:sale_price]). to include('deve ser maior ou igual a 0')
  end

  it 'Seller domain automatically fills in' do
    user = Collaborator.create(email: 'user@email.com', password: '123456')
    category = ProductCategory.create(name: 'Categoria')

    product = Product.create(name: 'Nome', description: 'Descrição', sale_price: 10,
                            product_category: category, collaborator: user)

    expect(product.seller_domain).to eq(user.domain)
  end
end
