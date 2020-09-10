require 'rails_helper'

feature 'Seller changes product state' do
  scenario 'to avaiable' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Vendedor',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Comprador',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller,
                            status: :invisible)

    login_as(seller, scope: :collaborator)
    visit product_path(product)
    click_on 'Visível'
    login_as(buyer, scope: :collaborator)
    visit product_path(product)

    product.reload
    expect(product).to be_avaiable
    expect(page).to have_content(product.name)
    expect(page).to have_content(seller.name)
    expect(page).to have_button('R$ 40,00')
  end

  scenario 'to invisible' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Vendedor',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Comprador',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)

    login_as(seller, scope: :collaborator)
    visit product_path(product)
    click_on 'Invisível'
    login_as(buyer, scope: :collaborator)
    visit product_path(product)

    product.reload
    expect(product).to be_invisible
    expect(page).to have_content('Parece que este anúncio já foi tirado do ar! Talvez ele tenha sido cancelado, vendido, ou está invisível.')
    expect(page).to_not have_content(product.name)
    expect(page).to_not have_content(seller.name)
  end

  scenario 'to canceled' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Vendedor',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Comprador',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)

    login_as(seller, scope: :collaborator)
    visit product_path(product)
    click_on 'Cancelar'
    login_as(buyer, scope: :collaborator)
    visit product_path(product)

    product.reload
    expect(product).to be_canceled
    expect(page).to have_content('Parece que este anúncio já foi tirado do ar! Talvez ele tenha sido cancelado, vendido, ou está invisível.')
    expect(page).to_not have_content(product.name)
    expect(page).to_not have_content(seller.name)
  end

  scenario 'but cannot because product is in negotiation' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Vendedor',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Comprador',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)
    negotiation = Negotiation.create(product: product, collaborator: buyer, status: :negotiating)

    login_as(seller, scope: :collaborator)
    visit product_path(product)
    click_on 'Cancelar'

    product.reload
    expect(product).to be_avaiable
    expect(page).to have_content('Não é possível cancelar um produto que faz parte de uma negociação em andamento')
    expect(page).to have_content(product.name)
    expect(page).to have_content('Você é o dono deste produto')
  end
end
