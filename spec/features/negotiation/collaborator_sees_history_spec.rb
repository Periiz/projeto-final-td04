require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

feature 'Collaborator sees his history' do
  scenario 'sold negotiations' do
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
                             description: 'Bom livro', sale_price: 40, collaborator: seller,
                             status: :sold, buyer_id: buyer.id)
    negotiation = Negotiation.create(product: product, collaborator: buyer, status: :sold,
                                     date_of_start: agora-1, date_of_end: agora, final_price: 50)

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

    expect(page).to have_content('Você ainda não tem produtos vendidos.')
  end

  scenario 'nothing bought' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))

    login_as(seller, scope: :collaborator)
    visit collaborator_path(seller)
    click_on 'Histórico'
    click_on 'Compras'

    expect(page).to have_content('Você ainda não tem produtos comprados.')
  end

  scenario 'doest not have canceled products' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))

    login_as(seller, scope: :collaborator)
    visit history_collaborator_path(seller)
    click_on 'Cancelados'

    expect(page).to have_content('Você ainda não tem produtos cancelados.')
  end

  scenario 'has canceled products' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))
    category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: category,
                             sale_price: 40, description: 'Bom livro', collaborator: seller)

    login_as(seller, scope: :collaborator)
    visit product_path(product)
    click_on 'Cancelar'
    visit history_collaborator_path(seller)
    click_on 'Cancelados'

    expect(page).to have_content(product.name)
    expect(page).to have_content('R$ 40,00')
  end
end
