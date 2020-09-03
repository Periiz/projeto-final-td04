require 'rails_helper'

feature 'Collaborator sees negotiation' do
  context 'as seller' do
    scenario 'with negotiation still waiting' do
        seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                    full_name:'Usuário Vendedor', social_name: 'Seller',
                                    position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
        buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                    full_name:'Usuário Comprador', social_name: 'Buyer',
                                    position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

        product_category = ProductCategory.create!(name: 'Livros')
        product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                                description: 'Bom livro', sale_price: 40, collaborator: seller)
        negotiation = Negotiation.create(product: product, collaborator: buyer, seller_id: seller.id)

        login_as(seller, scope: :collaborator)
        visit root_path
        click_on 'Perfil'
        click_on 'Suas negociações'
        click_on product.name

        expect(page).to have_content('Você aceita essa negociação?')
        expect(page).to have_content(product.name)
        expect(page).to have_content(negotiation.buyer_name)
        expect(page).to have_content(negotiation.buyer_email)
    end

    scenario 'with negotiation on going' do
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
                                         status: 'negotiating')

        login_as(seller, scope: :collaborator)
        visit root_path
        click_on 'Perfil'
        click_on 'Suas negociações'
        click_on product.name

        expect(page).to have_content('Você quer confirmar ou cancelar essa negociação?')
        expect(page).to have_content(product.name)
        expect(page).to have_content(negotiation.buyer_name)
        expect(page).to have_content(negotiation.buyer_email)
    end
  end

  scenario 'as buyer' do
    seller = Collaborator.create!(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create!(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

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
end