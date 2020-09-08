require 'rails_helper'

feature 'Product photos' do
  scenario 'has one' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller)
    product.photos.attach(io: File.open(Rails.root.join('spec/support/capa-killing-defense.jpeg')),
                          filename: 'capa-killing-defense.jpeg', content_type:'image/png', identify: false)

    login_as(seller, scope: :collaborator)
    visit product_path(product)

    expect(Product.first.photos.length).to eq 1
    expect(page).to have_css('img[src*="capa-killing-defense.jpeg"]')
  end

  scenario 'has many' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    product_category = ProductCategory.create(name: 'Livros')

    capa = Rails.root.join('spec/support/capa-killing-defense.jpeg')
    costas = Rails.root.join('spec/support/costas-killing-defense.jpeg')

    login_as(seller, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Seus anúncios'
    click_on 'Anunciar'
    fill_in 'Nome do Produto', with: 'Killing Defense at Bridge'
    select 'Livros', from: 'Categoria'
    fill_in 'Descrição', with: 'Livro em bom estado, Killing Defense at Bridge do Hugh Kelsey, leitura obrigatória para qualquer jogador querendo melhorar seu nível!'
    fill_in 'Preço de Venda', with: '40'
    attach_file 'Fotos', [capa, costas]
    click_on 'Anunciar'
    click_on 'Mais fotos'

    expect(Product.first.photos.length).to eq 2
    expect(page).to have_css('img[src*="capa-killing-defense.jpeg"]')
    expect(page).to have_css('img[src*="costas-killing-defense.jpeg"]')
  end

  scenario 'has none' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    product_category = ProductCategory.create(name: 'Livros')

    login_as(seller, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Seus anúncios'
    click_on 'Anunciar'
    fill_in 'Nome do Produto', with: 'Killing Defense at Bridge'
    select 'Livros', from: 'Categoria'
    fill_in 'Descrição', with: 'Livro em bom estado, Killing Defense at Bridge do Hugh Kelsey, leitura obrigatória para qualquer jogador querendo melhorar seu nível!'
    fill_in 'Preço de Venda', with: '40'
    click_on 'Anunciar'

    expect(Product.first.photos.length).to eq 0
    expect(page).to_not have_css('img[src*="capa-killing-defense.jpeg"]')
    expect(page).to_not have_css('img[src*="costas-killing-defense.jpeg"]')
    #TODO Por que esse teste não funciona?
    #expect(page).to have_css('img[src*="default_product.png"]')
  end

  scenario 'has many v2' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                             description: 'Bom livro', sale_price: 40, collaborator: seller)

    product.photos.attach(io: File.open(Rails.root.join('spec/support/capa-killing-defense.jpeg')),
                          filename: 'capa-killing-defense.jpeg', content_type:'image/png', identify: false)

    product.photos.attach(io: File.open(Rails.root.join('spec/support/costas-killing-defense.jpeg')),
                          filename: 'costas-killing-defense.jpeg', content_type:'image/png', identify: false)

    login_as(seller, scope: :collaborator)
    visit product_path(product)
    click_on 'Mais fotos'

    expect(Product.first.photos.length).to eq 2
    expect(page).to have_css('img[src*="capa-killing-defense.jpeg"]')
    expect(page).to have_css('img[src*="costas-killing-defense.jpeg"]')
  end
end
