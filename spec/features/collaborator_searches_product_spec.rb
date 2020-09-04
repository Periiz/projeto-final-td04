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
      product_category = ProductCategory.create!(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      another_product = Product.create!(name: "How to Read Your Opponent's Cards, Mike Lawrence",
                                        product_category: product_category, description: 'Muito bom livro',
                                        sale_price: 50, collaborator: seller, seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: product.name
      click_on 'Buscar'

      expect(page).to have_content('Killing')
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
      product_category = ProductCategory.create!(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      another_product = Product.create!(name: 'Adventures in Card Play, Hugh Kelsey', sale_price: 50,
                                        description: 'Encante-se com a beleza deste jogo fascinante e suas posições mirabolantes!',
                                        product_category: product_category, collaborator: seller,
                                        seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: 'Kelsey'
      click_on 'Buscar'

      expect(page).to have_content(product.name)
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(product.seller_name, count: 2)
      expect(page).to have_content(another_product.name)
      expect(page).to have_content('R$ 50,00')
    end

    scenario 'and did not find any (name problem)' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@different-email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create!(name: 'Livros')
      
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
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@different-email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create!(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Bom livro', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: product.name
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
      product_category = ProductCategory.create!(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Descrição diferente', sale_price: 40, collaborator: seller,
                              seller_domain: seller.domain)

      another_product = Product.create!(name: "How to Read Your Opponent's Cards, Mike Lawrence",
                                        product_category: product_category, description: 'Muito bom livro',
                                        sale_price: 50, collaborator: seller, seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: product.description
      click_on 'Buscar'

      expect(page).to have_content('Killing')
      expect(page).to have_content(product.name)
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(product.seller_name, count: 1)
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
      product_category = ProductCategory.create!(name: 'Livros')
      
      product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                              description: 'Descrição com a palavra jogo', sale_price: 40,
                              collaborator: seller, seller_domain: seller.domain)

      another_product = Product.create!(name: 'Adventures in Card Play, Hugh Kelsey', sale_price: 50,
                                        description: 'Encante-se com a beleza deste jogo fascinante e suas posições mirabolantes!',
                                        product_category: product_category, collaborator: seller,
                                        seller_domain: seller.domain)

      login_as(searcher, scope: :collaborator)
      visit root_path
      fill_in 'Busca de produtos', with: 'jogo'
      click_on 'Buscar'

      expect(page).to have_content(product.name)
      expect(page).to have_content('R$ 40,00')
      expect(page).to have_content(product.seller_name, count: 2)
      expect(page).to have_content(another_product.name)
      expect(page).to have_content('R$ 50,00')
    end

    scenario 'and did not find any (description problem)' do
      searcher = Collaborator.create(email:'user@email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'19/09/1995')
      seller = Collaborator.create(email:'seller@different-email.com', password:'123456',
                                  full_name:'Usuário Vendedor', social_name: 'Seller',
                                  position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
      product_category = ProductCategory.create!(name: 'Livros')
      
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
      product_category = ProductCategory.create!(name: 'Livros')
      
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
    xscenario 'finds many' do
      #
    end
  end
end
