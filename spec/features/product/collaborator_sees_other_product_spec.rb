require 'rails_helper'

feature "Collaborator sees another person's product" do
  scenario 'from product url' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    another_user = Collaborator.create!(email:'another@email.com', password:'098765',
                                full_name:'Outra Pessoa', social_name: 'Vendedor Teste',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: another_user)


    login_as(user, scope: :collaborator)
    visit product_path(product)

    expect(page).to have_content(another_user.name)
    expect(page).to have_content('Killing Defense, Hugh Kelsey')
    expect(page).to have_content('Vendedor Teste') #another_user.name
    expect(page).to have_button('R$ 40,00')
    expect(page).to_not have_content('Você não tem permissão para ver este produto!')
  end

  scenario "from another collaborator's profile" do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    another_user = Collaborator.create!(email:'another@email.com', password:'098765',
                                full_name:'Outra Pessoa', social_name: 'Vendedor Teste',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')
    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: another_user)

    login_as(user, scope: :collaborator)
    visit collaborator_path(another_user)
    click_on 'anúncios'
    click_on 'Killing Defense, Hugh Kelsey'

    expect(page).to have_content(product.name)
    expect(page).to have_content(product.description)
    expect(page).to have_button('R$ 40,00')
  end

  scenario "can't see from different companies" do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    another_user = Collaborator.create!(email:'another@different-email.com', password:'098765',
                                full_name:'Outra Pessoa', social_name: 'Vendedor Teste',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: another_user)

    login_as(user, scope: :collaborator)
    visit product_path(product)

    expect(page).to have_content('Você não tem permissão para ver este anúncio!')
    expect(page).to have_content('Somente anúncios feitos por pessoas da mesma empresa que você são visíveis.')
    expect(page).to have_link('Home Page', href: root_path)
    expect(page).to_not have_content(another_user.name)
    expect(page).to_not have_content('Killing Defense, Hugh Kelsey')
    expect(page).to_not have_content('Bom livro')
    expect(page).to_not have_content('R$ 40,00')
  end

  scenario "can't see invisible products" do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Vendedor',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Comprador',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)
    product.invisible!
    product.reload

    login_as(buyer, scope: :collaborator)
    visit product_path(product)

    expect(page).to have_content('este anúncio não está disponível no momento')
    expect(page).to_not have_content(product.name)
  end

  scenario "can't see sold products" do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller, status: :sold)
    negotiation = Negotiation.create(product: product, collaborator: buyer, status: :sold)

    login_as(buyer, scope: :collaborator)
    visit product_path(product)

    expect(page).to have_content('Este produto foi vendido!')
    expect(page).to have_link('Ver detalhes', href: negotiation_path(negotiation))
    expect(product).to_not have_content('omentário')
  end
end
