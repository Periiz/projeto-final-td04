require 'rails_helper'

feature 'Block routes for non authenticated visitors' do
  scenario 'home' do
    visit root_path

    expect(page).to have_content('Para continuar, faça login ou registre-se')
    expect(current_path).to_not eq root_path
  end

  context 'collaborator' do
    scenario 'profile' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')

      visit collaborator_path(person)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq collaborator_path(person)
    end

    scenario 'products' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')

      visit products_collaborator_path(person)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq products_collaborator_path(person)
    end

    scenario 'history' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')

      visit history_collaborator_path(person)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq history_collaborator_path(person)
    end

    scenario 'edit' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')

      visit edit_collaborator_path(person)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq edit_collaborator_path(person)
    end
  end

  context 'product' do
    scenario 'show' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')
      product = Product.create(name: 'Product Name', description: 'Product Description',
                               sale_price: 10, product_category: cat, collaborator: person)

      visit product_path(product)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq product_path(product)
    end

    scenario 'new' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')

      visit new_product_path

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq new_product_path
    end

    scenario 'edit' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')
      product = Product.create(name: 'Product Name', description: 'Product Description',
                               sale_price: 10, product_category: cat, collaborator: person)

      visit edit_product_path(product)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq edit_product_path(product)
    end

    scenario 'search' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')
      product = Product.create(name: 'Product Name', description: 'Product Description',
                               sale_price: 10, product_category: cat, collaborator: person)

      visit search_products_path

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq search_products_path
    end

    scenario 'photos' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')
      product = Product.create(name: 'Product Name', description: 'Product Description',
                               sale_price: 10, product_category: cat, collaborator: person)

      visit photos_product_path(product)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq photos_product_path(product)
    end
  end

  context 'negotiation' do
    scenario 'show' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')
      product = Product.create(name: 'Product Name', description: 'Product Description',
                               sale_price: 10, product_category: cat, collaborator: person)
      negot = Negotiation.create(product: product, collaborator: person)

      visit negotiation_path(negot)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq negotiation_path(negot)
    end

    scenario 'new' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')
      product = Product.create(name: 'Product Name', description: 'Product Description',
                               sale_price: 10, product_category: cat, collaborator: person)

      visit new_product_negotiation_path(product)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq new_product_negotiation_path(product)
    end

    scenario 'index' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')
      product = Product.create(name: 'Product Name', description: 'Product Description',
                               sale_price: 10, product_category: cat, collaborator: person)
      negot = Negotiation.create(product: product, collaborator: person)

      visit negotiations_path

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq negotiations_path
    end

    scenario 'confirm' do
      person = Collaborator.create(email: 'person@email.com', password: '123456')
      cat = ProductCategory.create(name: 'Categoria')
      product = Product.create(name: 'Product Name', description: 'Product Description',
                               sale_price: 10, product_category: cat, collaborator: person)
      negot = Negotiation.create(product: product, collaborator: person)

      visit confirm_negotiation_path(negot)

      expect(page).to have_content('Para continuar, faça login ou registre-se')
      expect(current_path).to_not eq confirm_negotiation_path(negot)
    end
  end
end
