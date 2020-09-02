require 'rails_helper'

feature 'Collaborator buys product' do
  scenario 'successfully' do
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
    visit product_path(product.id)
    puts "\n===========\n"
    puts current_path
    puts "===========\n"
    click_on "R$ 40,00"
    #TODO eu queria fazer um click_on number_to_currency(product.sale_price) mas não funciona :(
    visit collaborator_path(user.id)
    click_on 'Suas negociações'

    expect(product.status).to eq :confirmed
    expect(page).to have_content(product.name)
    expect(page).to have_content(another_user.name)
    expect(page).to have_content(another_user.email)
  end
end