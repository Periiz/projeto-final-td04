require 'rails_helper'

feature 'Collaborator searches product' do
  context 'by name' do
    scenario 'and finds one' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      another_product = Product.create(name: "How to Read Your Opponent's Cards, Mike Lawrence",
                                       product_category: product_category, description: 'Muito bom livro',
                                       sale_price: 50, collaborator: seller, seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: product.name
      click_on 'Buscar'

      expect(page).to have_content('Killing')
      expect(page).to have_content(product.description[0,50])
      expect(page).to have_content(product.name)
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(product.seller_name, count: 1) #Apenas uma vez! Não é pra achar o outro produto!
      #TODO Foto do produto!!!
      expect(page).to_not have_content(another_product.name)
      expect(page).to_not have_content('R$ 50,00')
    end

    scenario 'and finds many' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'03/10/1995')
      product_category = ProductCategory.create(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      another_product = Product.create(name: 'Adventures in Card Play, Hugh Kelsey', sale_price: 50,
                                       description: 'Encante-se com a beleza deste jogo fascinante e suas posições mirabolantes!',
                                       product_category: product_category, collaborator: seller,
                                       seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: 'Kelsey'
      click_on 'Buscar'

      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description[0,50])
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(product.seller_name, count: 2)
      expect(page).to have_content(another_product.name)
      expect(page).to have_content(another_product.description[0,50])
      expect(page).to have_content('R$ 50,00')
    end

    scenario 'and did not find any (name problem)' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@different-email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: 'Kantar'
      click_on 'Buscar'

      expect(page).to_not have_content(product.name)
      expect(page).to_not have_content('R$ 40,00')
      expect(page).to_not have_content(product.seller_name)
      expect(page).to have_content('Nenhum produto encontrado.')
    end

    scenario 'and did not find any (domain problem)' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Searcher',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@different-email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: 'Killing'
      click_on 'Buscar'

      expect(page).to_not have_content(product.name)
      expect(page).to_not have_content('R$ 40,00')
      expect(page).to_not have_content(product.seller_name)
      expect(page).to have_content('Nenhum produto encontrado.')
    end
  end

  context 'by description' do
    scenario 'and finds one' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Descrição diferente', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      another_product = Product.create(name: "How to Read Your Opponent's Cards, Mike Lawrence",
                                        product_category: product_category, description: 'Muito bom livro',
                                        sale_price: 50, collaborator: seller, seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: product.description
      click_on 'Buscar'

      expect(page).to have_content('Killing')
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description[0,50])
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(product.seller_name, count: 1)
      expect(page).to_not have_content(another_product.name)
      expect(page).to_not have_content(another_product.description[0,50])
      expect(page).to_not have_content('R$ 50,00')
    end

    scenario 'and finds many' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'03/10/1995')
      product_category = ProductCategory.create(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Descrição com a palavra jogo', sale_price: 40,
                              collaborator: seller, seller_domain: seller.domain)

      another_product = Product.create(name: 'Adventures in Card Play, Hugh Kelsey', sale_price: 50,
                                        description: 'Encante-se com a beleza deste jogo fascinante e suas posições mirabolantes!',
                                        product_category: product_category, collaborator: seller,
                                        seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: 'jogo'
      click_on 'Buscar'

      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description[0,50])
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(product.seller_name, count: 2)
      expect(page).to have_content(another_product.name)
      expect(page).to have_content(another_product.description[0,50])
      expect(page).to have_content('R$ 50,00')
    end

    scenario 'and did not find any (description problem)' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@different-email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: 'Descrição'
      click_on 'Buscar'

      expect(page).to_not have_content(product.name)
      expect(page).to_not have_content('R$ 40,00')
      expect(page).to_not have_content(product.seller_name)
      expect(page).to have_content('Nenhum produto encontrado.')
    end

    scenario 'and did not find any (domain problem)' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@different-email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: product.description
      click_on 'Buscar'

      expect(page).to_not have_content(product.name)
      expect(page).to_not have_content('R$ 40,00')
      expect(page).to_not have_content(product.seller_name)
      expect(page).to have_content('Nenhum produto encontrado.')
    end
  end

  context 'filtering category' do
    scenario 'finds one with that category filter' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

      wrong_seller = Collaborator.create(email:'hiddenseller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor Errado', social_name: 'Errou',
                                  position: 'Cargo', sector: 'Setor', birth_date:'10/01/1997')
      category_livro = ProductCategory.create(name: 'Livros')
      category_roupa = ProductCategory.create(name: 'Roupas')
      
      find_this_product = Product.create(name: 'Como costurar camisas que perderam botões',
                              product_category: category_livro, seller_domain: seller.domain,
                              description: 'Guia completo. Nunca mais fique com camisas sem botões!',
                              sale_price: 40, collaborator: seller)

      dont_find_this_product = Product.create(name: 'Camisa Social Bonita',
                                        product_category: category_roupa, sale_price: 50,
                                        description: 'Camisas novas 0 quilômetros, tratar por email',
                                        collaborator: wrong_seller, seller_domain: wrong_seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: 'Camisa'
      click_on 'Buscar'
      click_on 'Livros'

      expect(page).to have_content(find_this_product.name)
      expect(page).to have_content(find_this_product.description[0,50])
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(seller.name)
      expect(page).to_not have_content(dont_find_this_product.name)
      expect(page).to_not have_content('R$ 50,00')
    end

    scenario 'finds many with that category filter' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

      wrong_seller = Collaborator.create(email:'hiddenseller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor Errado', social_name: 'Errou',
                                  position: 'Cargo', sector: 'Setor', birth_date:'10/01/1997')
      category_livro = ProductCategory.create(name: 'Livros')
      category_roupa = ProductCategory.create(name: 'Roupas')
      
      find_this_product_1 = Product.create(name: 'Como costurar camisas que perderam botões',
                              product_category: category_livro, seller_domain: seller.domain,
                              description: 'Guia completo. Nunca mais fique com camisas sem botões!',
                              sale_price: 40, collaborator: seller)

      find_this_product_2 = Product.create(name: 'Adventures in Card Play, Hugh Kelsey',
                                        description: 'Encante-se com a beleza deste jogo fascinante e suas posições mirabolantes!',
                                        product_category: category_livro, collaborator: seller,
                                        seller_domain: seller.domain, sale_price: 50)

      dont_find_this_product = Product.create(name: 'Camisa Social Bonita', 
                                        product_category: category_roupa, sale_price: 60,
                                        description: 'Camisas novas 0 quilômetros, tratar por email',
                                        collaborator: wrong_seller, seller_domain: wrong_seller.domain)


      login_as(searcher, scope: :collaborator)
      visit root_path
      click_on 'Buscar' #Busca todos os produtos
      click_on category_livro.name #Escolhe a categoria livros


      expect(page).to have_content(find_this_product_1.name)
      expect(page).to have_content(find_this_product_1.description[0,50])
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(seller.name, count: 2)
      expect(page).to have_content(find_this_product_2.name)
      expect(page).to have_content(find_this_product_2.description[0,50])
      expect(page).to have_content('R$ 50,00')
      expect(page).to_not have_content(dont_find_this_product.name)
      expect(page).to_not have_content(dont_find_this_product.description[0,50])
      expect(page).to_not have_content(wrong_seller.name)
      expect(page).to_not have_content('R$ 60,00')
    end

    scenario "doesn't find any with that filter" do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

      category_livro = ProductCategory.create(name: 'Livros')
      category_roupa = ProductCategory.create(name: 'Roupas')
      
      product_1 = Product.create(name: 'Como costurar camisas que perderam botões',
                              product_category: category_livro, seller_domain: seller.domain,
                              description: 'Guia completo. Nunca mais fique com camisas sem botões!',
                              sale_price: 40, collaborator: seller)

      product_2 = Product.create(name: 'Adventures in Card Play, Hugh Kelsey',
                                        description: 'Encante-se com a beleza deste jogo fascinante e suas posições mirabolantes!',
                                        product_category: category_livro, collaborator: seller,
                                        seller_domain: seller.domain, sale_price: 50)


      login_as(searcher, scope: :collaborator)
      visit root_path
      click_on 'Buscar'
      click_on category_roupa.name

      expect(page).to have_content('Nenhum produto encontrado.')
      expect(page).to_not have_content(product_1.name)
      expect(page).to_not have_content(product_1.description[0,50])
      expect(page).to_not have_content(seller.name)
      expect(page).to_not have_content('R$ 40,00')
      expect(page).to_not have_content(product_2.name)
      expect(page).to_not have_content(product_2.description[0,50])
      expect(page).to_not have_content(seller.name)
      expect(page).to_not have_content('R$ 50,00')
    end

    scenario 'uses all categories option' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    end
  end

  scenario 'cannot find own product' do
    user = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    product_category = ProductCategory.create(name: 'Livros')
    
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: user)

    login_as(user, scope: :collaborator)
    visit root_path
    fill_in 'Busca de produtos', with: 'Killing'
    click_on 'Buscar'

    expect(page).to_not have_content(product.name)
    expect(page).to_not have_content(product.description[0,50])
    expect(page).to_not have_content('R$ 40,00')
  end

  scenario 'cannot find invisible product' do
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
    visit root_path
    fill_in 'Busca de produtos', with: 'Killing'
    click_on 'Buscar'

    expect(page).to have_content('Buscando por')
    expect(page).to have_content('Nenhum produto encontrado')
    expect(page).to_not have_content(product.name)
    expect(page).to_not have_content(product.description[0,50])
    expect(page).to_not have_content('R$ 40,00')
  end

  scenario "can't find product in negotiation" do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                 full_name:'Usuário Vendedor', social_name: 'Seller',
                                 position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    buyer = Collaborator.create(email:'buyer@email.com', password:'098765',
                                full_name:'Usuário Comprador', social_name: 'Buyer',
                                position: 'Cargo', sector: 'Setor', birth_date:'10/01/1997')
    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)

    login_as(buyer, scope: :collaborator)
    visit product_path(product)
    click_on 'R$ 40,00'
    click_on 'Iniciar Negociação'
    product.reload
    visit root_path
    click_on 'Buscar'

    expect(page).to have_content('Nenhum produto encontrado')
    expect(page).to_not have_content(product.name)
    expect(page).to_not have_content(product.description[0,50])
    expect(page).to_not have_content('R$ 40,00')
  end
end
