require 'rails_helper'

feature 'Buyer and seller send private messages on negotiation screen' do
  scenario 'successfully' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date: Date.parse('10/01/1997'))

    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer,
                                     seller_id: seller.id, status: 'negotiating')

    login_as(seller, scope: :collaborator)
    visit negotiation_path(negotiation)
    fill_in 'Escreva algo', with: '¿Holanda, qué talka?'
    click_on 'Enviar'

    login_as(buyer, scope: :collaborator)
    visit negotiation_path(negotiation)
    fill_in 'Escreva algo', with: 'masoq?'
    click_on 'Enviar'

    expect(page).to have_content("#{seller.name}: ¿Holanda, qué talka?")
    expect(page).to have_content("#{buyer.name}: masoq?")
  end

  scenario 'message cannot be blank' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date: Date.parse('10/01/1997'))

    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer,
                                     seller_id: seller.id, status: 'negotiating')

    login_as(seller, scope: :collaborator)
    visit negotiation_path(negotiation)
    click_on 'Enviar'

    expect(Message.last).to be_blank
  end
end
