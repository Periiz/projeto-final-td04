require 'rails_helper'

feature "Collaborator sees another person's product" do
  context 'both from the same company' do
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
      expect(page).to have_content('R$ 40,00')
      expect(page).to_not have_content('Você não tem permissão para ver este produto!')
    end

    xscenario "from another collaborator's profile" do
      # Fazer isso depois
    end
  end

  context 'from different companies' do
    scenario 'from product url' do
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
      expect(page).to have_link('Voltar', href: root_path)
      expect(page).to_not have_content(another_user.name)
      expect(page).to_not have_content('Killing Defense, Hugh Kelsey')
      expect(page).to_not have_content('Bom livro')
      expect(page).to_not have_content('R$ 40,00')
    end

    xscenario "from another collaborator's profile" do
      # Fazer isso depois, quando puder ver os perfis alheios
    end
  end
end