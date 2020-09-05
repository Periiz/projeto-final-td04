require 'rails_helper'

feature 'Collaborator sees negotiation' do
  context 'as seller' do
    scenario 'with negotiation still waiting' do
      seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                    full_name:'Usuário Vendedor', social_name: 'Seller',
                                    position: 'Cargo', sector: 'Setor', birth_date:Date.parse('08/08/1994'))
      buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                  full_name:'Usuário Comprador', social_name: 'Buyer',
                                  position: 'Cargo', sector: 'Setor', birth_date:Date.parse('10/01/1997'))

      product_category = ProductCategory.create!(name: 'Livros')
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller)
      negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id)

      login_as(seller, scope: :collaborator)
      visit root_path
      click_on 'Perfil'
      click_on 'negociações'
      click_on product.name

      expect(page).to have_content('Você aceita esta negociação?')
      expect(page).to have_content(product.name)
      expect(page).to have_content(negotiation.buyer_name)
      expect(page).to have_content(negotiation.buyer_email)
    end

    scenario 'with negotiation on going' do
      seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                    full_name:'Usuário Vendedor', social_name: 'Seller',
                                    position: 'Cargo', sector: 'Setor', birth_date:Date.parse('08/08/1994'))
      buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                  full_name:'Usuário Comprador', social_name: 'Buyer',
                                  position: 'Cargo', sector: 'Setor', birth_date:Date.parse('10/01/1997'))

      product_category = ProductCategory.create!(name: 'Livros')
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                               description: 'Bom livro', sale_price: 40, collaborator: seller)
      negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id,
                                       status: 'negotiating')

      login_as(seller, scope: :collaborator)
      visit root_path
      click_on 'Perfil'
      click_on 'Suas negociações'
      click_on product.name

      expect(page).to have_content('Você pode CONFIRMAR ou CANCELAR esta negociação.')
      expect(page).to have_content(product.name)
      expect(page).to have_content(negotiation.buyer_name)
      expect(page).to have_content(negotiation.buyer_email)
    end

    scenario 'and accepts it' do
      seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                    full_name:'Usuário Vendedor', social_name: 'Seller',
                                    position: 'Cargo', sector: 'Setor', birth_date:Date.parse('08/08/1994'))
      buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                  full_name:'Usuário Comprador', social_name: 'Buyer',
                                  position: 'Cargo', sector: 'Setor', birth_date:Date.parse('10/01/1997'))

      product_category = ProductCategory.create!(name: 'Livros')
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                               description: 'Bom livro', sale_price: 40, collaborator: seller)
      negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id)

      login_as(seller, scope: :collaborator)
      visit root_path
      click_on 'Perfil'
      click_on 'negociações'
      click_on product.name
      click_on 'Sim'
      negotiation.reload

      expect(negotiation).to be_negotiating
      expect(page).to_not have_content('Você aceita esta negociação?')
      expect(page).to have_content('Você pode CONFIRMAR ou CANCELAR esta negociação.')
    end

    scenario 'and rejects it' do
      seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                    full_name:'Usuário Vendedor', social_name: 'Seller',
                                    position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))
      buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                  full_name:'Usuário Comprador', social_name: 'Buyer',
                                  position: 'Cargo', sector: 'Setor', birth_date: Date.parse('10/01/1997'))

      product_category = ProductCategory.create!(name: 'Livros')
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                               description: 'Bom livro', sale_price: 40, collaborator: seller)
      negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id)

      login_as(seller, scope: :collaborator)
      visit root_path
      click_on 'Perfil'
      click_on 'negociações'
      click_on product.name
      click_on 'Não'
      negotiation.reload

      expect(negotiation).to be_canceled
      expect(page).to_not have_content('Você aceita esta negociação?')
      expect(page).to have_content('Esta negociação foi cancelada :(')
      expect(page).to have_content('O produto era:')
      expect(page).to have_content(product.name)
      expect(page).to have_content(seller.name)
      expect(page).to have_content(seller.email)
    end

    scenario 'and accepts it to later cancel it' do
      seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                    full_name:'Usuário Vendedor', social_name: 'Seller',
                                    position: 'Cargo', sector: 'Setor', birth_date:Date.parse('08/08/1994'))
      buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                  full_name:'Usuário Comprador', social_name: 'Buyer',
                                  position: 'Cargo', sector: 'Setor', birth_date:Date.parse('10/01/1997'))

      product_category = ProductCategory.create!(name: 'Livros')
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                               description: 'Bom livro', sale_price: 40, collaborator: seller)
      negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id)

      login_as(seller, scope: :collaborator)
      visit root_path
      click_on 'Perfil'
      click_on 'negociações'
      click_on product.name
      click_on 'Sim'
      negotiation.reload
      visit negotiation_path(negotiation)
      click_on 'Cancelar'
      negotiation.reload

      expect(negotiation).to be_canceled
      expect(negotiation).to_not be_negotiating
      expect(page).to have_content('Esta negociação foi cancelada :(')
      expect(page).to have_content(product.name)
      expect(page).to have_content(negotiation.seller_name)
      expect(page).to have_content(negotiation.seller_email)
    end
  
    scenario 'and accepts and later sells the product' do
      seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                    full_name:'Usuário Vendedor', social_name: 'Seller',
                                    position: 'Cargo', sector: 'Setor', birth_date: Date.parse('08/08/1994'))
      buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                  full_name:'Usuário Comprador', social_name: 'Buyer',
                                  position: 'Cargo', sector: 'Setor', birth_date:Date.parse('10/01/1997'))

      product_category = ProductCategory.create!(name: 'Livros')
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                               description: 'Bom livro', sale_price: 40, collaborator: seller)
      negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id,
                                       date_of_start: DateTime.current)

      login_as(seller, scope: :collaborator)
      visit root_path
      click_on 'Perfil'
      click_on 'negociações'
      click_on product.name
      click_on 'Sim'
      negotiation.reload
      visit negotiation_path(negotiation)
      click_on 'Confirmar'
      fill_in 'Preço Final', with: 50
      click_on 'Confirmar'
      negotiation.reload

      expect(negotiation).to be_sold #Whyyyyyy
      expect(negotiation).to_not be_negotiating
      expect(negotiation).to_not be_canceled
      expect(page).to have_content('Esta negociação foi concluída!')
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description)
      expect(page).to have_content(negotiation.buyer_name)
      expect(page).to have_content(negotiation.buyer_email)
      expect(page).to have_content('R$ 50,00')
      #expect(page).to have_content(negotiation.date_of_end) Como que eu testo isso?
    end
  end

  scenario 'as buyer' do
    seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date:'10/01/1997')

    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id)

    login_as(buyer, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Suas negociações'
    click_on product.name

    expect(page).to have_content(product.name)
    expect(page).to have_content(negotiation.seller_name)
    expect(page).to have_content(negotiation.seller_email)
  end

  scenario 'without having any yet' do
    user = Collaborator.create!(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'negociações'

    expect(page).to have_content('Você não tem negociações no momento.')
  end

  scenario 'as someone not related to it' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date:'10/01/1997')
    peeker = Collaborator.create(email:'peeker@email.com', password:'321789',
                                full_name:'Usuário Enxerido', social_name: 'Peeker',
                                position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id)

    login_as(peeker, scope: :collaborator)
    visit negotiation_path(negotiation)

    expect(page).to have_content('Somente pessoas envolvidas na negociação podem ver detalhes da mesma.')
  end
end