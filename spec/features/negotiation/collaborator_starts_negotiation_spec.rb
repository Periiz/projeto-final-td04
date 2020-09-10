require 'rails_helper'

feature 'Collaborator starts negotiation' do
  scenario 'successfully' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)

    login_as(buyer, scope: :collaborator)
    visit product_path(product)
    click_on "R$ 40,00"
    click_on 'Iniciar Negociação'

    expect(Negotiation.last.waiting?).to eq true
    expect(page).to have_content(product.name)
    expect(page).to have_content(seller.name)
    expect(page).to have_content(seller.email)
    expect(page).to have_content(buyer.name)
    expect(page).to have_content(buyer.email)
  end

  scenario "can't start negotiation on same product twice" do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)

    login_as(buyer, scope: :collaborator)
    visit product_path(product)
    click_on "R$ 40,00"
    click_on 'Iniciar Negociação'
    visit product_path(product)

    expect(page).to_not have_button('R$ 40,00')
    expect(page).to have_content('Você já tem uma negociação deste produto.')
    expect(page).to have_link('Ver negociação', href: negotiation_path(Negotiation.first))
  end
end
