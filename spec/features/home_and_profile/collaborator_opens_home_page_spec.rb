require 'rails_helper'

feature 'Opening homepage' do
  scenario 'has to login' do
    visit root_path

    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(page).to have_content('Login')
    expect(page).to have_content('Email')
    expect(page).to have_content('Senha')
    expect(page).to have_content('Remember me')
    expect(page).to have_content('Login') #Entrar
    expect(page).to have_content('Inscrever-se')
    expect(page).to have_content('Esqueceu sua senha?')
    expect(page).not_to have_content('Bem vindo ao Market Place!')
    expect(page).not_to have_content('Perfil')
    expect(page).not_to have_content('Busca')
  end

  scenario 'logged in' do
    Collaborator.create(email: 'pessoa@email.com', password:'123456')

    visit root_path
    fill_in 'Email', with: 'pessoa@email.com'
    fill_in 'Senha', with: '123456'
    check 'Remember me'
    click_on 'Login'

    expect(page).to have_content('Login efetuado com sucesso.')
    expect(page).to have_content('Market Place')
    expect(page).to have_content('Bem vindo ao Market Place, seu site corporativo de compras e vendas')
    expect(page).to have_link('Perfil')
    expect(page).to have_link('Anuncie aqui')
    expect(page).to have_link('Sair', href: destroy_collaborator_session_path)
    expect(page).to have_content('Busca')
  end

  scenario 'logs out' do
    user = Collaborator.create(email:'user@email.com', password:'123456')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Sair'

    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(page).to have_content('Login')
    expect(page).to have_content('Email')
    expect(page).to_not have_content('Market Place')
    expect(page).to_not have_content("#{user.name} - #{user.email}")
    expect(page).to_not have_content('Perfil')
  end

  scenario 'finds products at homepage' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: '08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date: '01/01/1997')
    product_category = ProductCategory.create(name: 'Livros')
    product_1 = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                               description: 'Bom livro', sale_price: 80, collaborator: seller, seller_domain: seller.domain)
    product_2 = Product.create(name: 'Um curso de cálculo 1, H.L. Guidorizzi', product_category: product_category,
                               description: 'Um clássico, porém claramente pior que o Spivak', sale_price: 90,
                               collaborator: seller, seller_domain: seller.domain)
    product_3 = Product.create(name: 'Calculus, M. Spivak', product_category: product_category,
                               description: 'O melhor livro de cálculo que você já viu!',
                               sale_price: 150, collaborator: seller, seller_domain: seller.domain)
    product_4 = Product.create(name: 'Cem Anos de Solidão, G.G. Márquez', product_category: product_category,
                               description: 'Verdadeira obra prima!!!', sale_price: 40,
                               collaborator: seller, seller_domain: seller.domain)
    product_5 = Product.create(name: 'As veias abertas da América Latina, E. Galeano',
                               product_category: product_category, seller_domain: seller.domain,
                               description: 'Todos deveriam ler', sale_price: 40, collaborator: seller)

    login_as(buyer, scope: :collaborator)
    visit root_path

    expect(page).to have_content('Alguns produtos anunciados')
    expect(page).to have_content(product_5.name)
    expect(page).to have_content(product_4.name)
    expect(page).to have_content(product_3.name)
    expect(page).to_not have_content(product_2.name)
    expect(page).to_not have_content(product_1.name)
  end
  
  scenario 'does not find own product at homepage' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date: '08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date: '01/01/1997')
    product_category = ProductCategory.create(name: 'Livros')
    product_1 = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                               description: 'Bom livro', sale_price: 80, collaborator: seller)
    product_2 = Product.create(name: 'Um curso de cálculo 1, H.L. Guidorizzi', product_category: product_category,
                               description: 'Um clássico, porém claramente pior que o Spivak', sale_price: 90,
                               collaborator: buyer)

    login_as(buyer, scope: :collaborator)
    visit root_path

    expect(page).to have_content('Alguns produtos anunciados')
    expect(page).to have_content(product_1.name)
    expect(page).to_not have_content(product_2.name)
  end

  scenario 'filters products at homepage' do
    searcher = Collaborator.create(email: 'user@email.com', password: '123456',
                                full_name: 'Usuário Buscador', social_name: 'Searcher',
                                position: 'Cargo', sector: 'Setor', birth_date: '19/09/1995')
    seller = Collaborator.create(email:' seller@email.com', password: '123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date: '08/08/1994')
    books = ProductCategory.create(name: 'Livros')
    clothes = ProductCategory.create(name: 'Roupas')
    find_this_product = Product.create(name: 'Como costurar camisas que perderam botões',
                            product_category: books, sale_price: 40, collaborator: seller,
                            description: 'Guia completo. Nunca mais fique com camisas sem botões!')
    dont_find_this_product = Product.create(name: 'Camisa Social Bonita', collaborator: seller,
                                      product_category: clothes, sale_price: 50,
                                      description: 'Camisas novas 0 quilômetros, tratar por email')

    login_as(searcher, scope: :collaborator)
    visit root_path
    click_on 'Livros'

    expect(page).to have_content(find_this_product.name)
    expect(page).to_not have_content(dont_find_this_product.name)
  end
end
