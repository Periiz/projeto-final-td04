require 'rails_helper'

feature 'Collaborator sees his history' do
  scenario 'sold itens/negotiations' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date: Date.parse('10/01/1997'))
    product_category = ProductCategory.create(name: 'Livros')
    agora = DateTime.current
    end_date_formatted = agora.strftime("%d/%m/") + agora.year.to_s
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer,
                                     status: :sold, date_of_start: agora-1,
                                     date_of_end: agora, final_price: 50)

    login_as(seller, scope: :collaborator)
    visit collaborator_path(seller)
    click_on 'Histórico'
    click_on 'Vendas'

    expect(page).to have_content('Vendas')
    expect(page).to have_content(negotiation.product.name)
    expect(page).to have_content(negotiation.buyer_name)
    expect(page).to have_content(end_date_formatted)
    expect(page).to have_content('R$ 50,00')
  end

  scenario 'bought itens/negotiations' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date: Date.parse('10/01/1997'))
    product_category = ProductCategory.create(name: 'Livros')
    agora = DateTime.current
    end_date_formatted = agora.strftime("%d/%m/") + agora.year.to_s
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer,
                                     status: :sold, date_of_start: agora-1,
                                     date_of_end: agora, final_price: 50)

    login_as(buyer, scope: :collaborator)
    visit collaborator_path(buyer)
    click_on 'Histórico'
    click_on 'Compras'

    expect(page).to have_content('Vendas')
    expect(page).to have_content(negotiation.product.name)
    expect(page).to have_content(negotiation.buyer_name)
    expect(page).to have_content(end_date_formatted)
    expect(page).to have_content('R$ 50,00')
    expect(page).to have_link('Ver detalhes', href: product_path(product))
  end

  scenario 'with details of negotiations' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date: Date.parse('10/01/1997'))
    product_category = ProductCategory.create(name: 'Livros')
    agora = DateTime.current
    end_date_formatted = agora.strftime("%d/%m/") + agora.year.to_s
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller, status: :sold)
    negotiation = Negotiation.create(product: product, collaborator: buyer,
                                     status: :sold, date_of_start: agora-1,
                                     date_of_end: agora, final_price: 50)

    login_as(seller, scope: :collaborator)
    visit collaborator_path(seller)
    click_on 'Histórico'
    click_on 'Vendas'
    click_on 'Ver detalhes'
    click_on 'Ver negociação'

    expect(page).to have_content('Detalhes da negociação')
    expect(page).to have_content(product.name)
    expect(page).to have_content(product.description)
    expect(page).to have_content(buyer.name)
    expect(page).to have_content(seller.name)
    expect(page).to have_content(seller.name)
    expect(page).to have_content('Mensagens trocadas entre colaboradores')
  end

  scenario 'nothing sold' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))

    login_as(seller, scope: :collaborator)
    visit collaborator_path(seller)
    click_on 'Histórico'
    click_on 'Vendas'

    expect(page).to have_content('Você não tem produtos vendidos ainda.')
  end

  scenario 'nothing bought' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))

    login_as(seller, scope: :collaborator)
    visit collaborator_path(seller)
    click_on 'Histórico'
    click_on 'Compras'

    expect(page).to have_content('Você não tem produtos comprados ainda.')
  end
end
