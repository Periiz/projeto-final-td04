require 'rails_helper'

feature 'Seller sees notification' do
  scenario 'from home page' do
    seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                 full_name:'Usuário Comprador', social_name: 'Buyer',
                                 position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id,
                                     date_of_start: DateTime.current, status: :waiting)

    login_as(seller, scope: :collaborator)
    visit root_path

    expect(page).to have_content('Alguém se interessou por algum produto seu!')
    expect(page).to have_link('Veja suas negociações!', href: negotiations_path)
    expect(seller.notif_count).to eq 1
  end

  scenario 'and dismisses the notification' do
    seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                 full_name:'Usuário Comprador', social_name: 'Buyer',
                                 position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id,
                                     date_of_start: DateTime.current, status: :waiting)

    login_as(seller, scope: :collaborator)
    visit root_path
    click_on 'Veja suas negociações!'
    click_on product.name
    click_on 'Sim'
    visit root_path

    expect(page).to_not have_content('Alguém se interessou por algum produto seu!')
    expect(page).to_not have_link('Veja suas negociações!', href: negotiations_path)
    expect(seller.notif_count).to eq 0
  end
end
