require 'rails_helper'

feature 'Collaborator sees all of his products' do
  scenario 'from profile' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: user)

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Seus anúncios'

    expect(page).to have_content('Seus anúncios')
    expect(page).to have_content('Killing Defense')
    #Foto seria legal, hein
    expect(page).to have_content('R$ 40,00')
    expect(page).to_not have_content('Bom livro')
  end

  scenario 'did not post any product yet' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Seus anúncios'

    expect(page).to have_content('Você ainda não fez nenhum anúncio!')
    expect(page).to have_content('Para anunciar algum item à venda, clique em Anunciar!')
    expect(page).to have_link('Anunciar', href: new_product_path)
  end

  scenario "can't see sold products" do
    user = Collaborator.create(email: 'user@email.com', password: '123456', 
                               full_name: 'Test User', social_name: 'User',
                               position: 'A', sector: 'B', birth_date: DateTime.current)
    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: user)
    product.sold!
    product.reload

    login_as(user, scope: :collaborator)
    visit products_collaborator_path(user)

    expect(page).to have_content('Você ainda não fez nenhum anúncio!')
    expect(page).to have_link('Anunciar')
    expect(page).to_not have_content(product.name)
  end

  scenario 'did not fill profile yet' do
    user = Collaborator.create!(email:'user@email.com', password:'123456')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Perfil'

    expect(page).to_not have_link('Seus anúncios', href: products_collaborator_path(user))
  end

  scenario "does not see someone else's product" do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    another_user = Collaborator.create!(email:'another@different-email.com', password:'098765',
                                full_name:'Outra Pessoa', social_name: 'Vendedor Teste',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create!(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: user)
    another_product = Product.create!(name: "How to Read Your Opponent's Cards, Mike Lawrence",
                                      product_category: product_category, description: 'Muito bom livro',
                                      sale_price: 50, collaborator: another_user)


    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Seus anúncios'


    expect(page).to have_content('Killing Defense')
    expect(page).to have_content('R$ 40,00')
    expect(page).to_not have_content('How to Read')
    expect(page).to_not have_content('R$ 50,00')
    expect(page).to_not have_content('Bom livro')
    expect(page).to_not have_content('Muito bom livro')
  end
end
