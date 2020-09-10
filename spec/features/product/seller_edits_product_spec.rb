require 'rails_helper'

feature 'Seller edits product' do
  scenario 'successfully' do
    user = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Vendedor',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    category_a = ProductCategory.create(name: 'Categoria Antiga')
    category_b = ProductCategory.create(name: 'Categoria Nova')
    product = Product.create(name: 'Nome Antigo', product_category: category_a,
                            description: 'Descriçao Antiga', sale_price: 10, collaborator: user)

    login_as(user)
    visit product_path(product)
    click_on 'Editar'

    fill_in 'Nome do Produto', with: 'Nome Novo'
    select 'Categoria Nova', from: 'Categoria'
    fill_in 'Descrição', with: 'Descrição Nova'
    fill_in 'Preço de Venda', with: 20
    click_on 'Anunciar'

    expect(page).to have_content('Produto editado com sucesso!')
    expect(page).to have_content('Nome Novo')
    expect(page).to have_content('Descrição Nova')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('Ainda não há comentários.')
    expect(page).to_not have_content('Nome Antigo')
    expect(page).to_not have_content('Descrição Antiga')
    expect(page).to_not have_content('R$ 10,00')
    expect(product.reload.product_category.name).to eq 'Categoria Nova'
  end

  scenario 'tries invalid values' do
    user = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Vendedor',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    category = ProductCategory.create(name: 'Categoria')
    product = Product.create(name: 'Nome', product_category: category,
                            description: 'Descriçao', sale_price: 10, collaborator: user)

    login_as(user)
    visit product_path(product)
    click_on 'Editar'
    fill_in 'Nome do Produto', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Preço de Venda', with: -1
    click_on 'Anunciar'

    expect(page).to have_content('não pode ficar em branco', count: 2)
    expect(page).to have_content('deve ser maior ou igual a 0')
  end

  scenario 'changes photos' do
    user = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Vendedor',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    category = ProductCategory.create(name: 'Categoria')
    product = Product.create(name: 'Nome', product_category: category,
                            description: 'Descriçao', sale_price: 10, collaborator: user)
    product.photos.attach(io: File.open(Rails.root.join('spec/support/costas-killing-defense.jpeg')),
                          filename: 'costas-killing-defense.jpeg', content_type:'image/jpeg', identify: false)

    login_as(user)
    visit product_path(product)
    click_on 'Editar'
    attach_file 'Foto', Rails.root.join('spec/support/capa-killing-defense.jpeg')
    click_on 'Anunciar'

    expect(page).to have_css('img[src*="capa-killing-defense.jpeg"]')
    expect(page).to_not have_css('img[src*="costas-killing-defense.jpeg"]')
  end
end
