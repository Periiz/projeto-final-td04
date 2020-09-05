require 'rails_helper'

feature 'Collaborator posts a new product' do
  scenario 'successfully' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:Date.parse('08/08/1994'))
    product_category = ProductCategory.create!(name: 'Livros')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Anuncie aqui'
    fill_in 'Nome do Produto', with: 'Killing Defense at Bridge'
    select 'Livros', from: 'Categoria'
    #TODO Fotos?
    fill_in 'Descrição', with: 'Livro em bom estado, Killing Defense at Bridge do Hugh Kelsey, leitura obrigatória para qualquer jogador querendo melhorar seu nível!'
    fill_in 'Preço de Venda', with: '40'
    click_on 'Anunciar'

    expect(page).to have_content('Produto anunciado com sucesso!')
    expect(page).to have_content('Você é o dono deste produto')
    expect(page).to have_content('Killing Defense')
    expect(page).to have_content('Livro em bom estado, Killing Defense at Bridge do Hugh Kelsey, leitura obrigatória para qualquer jogador querendo melhorar seu nível!')
    expect(page).to have_content('R$ 40,00')
    expect(page).to have_content('Ninguém deixou nenhum comentário ainda.')
  end

  scenario 'must fill all fields' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Anuncie aqui'
    click_on 'Anunciar'

    expect(page).to have_content('Categoria é obrigatório(a)')
    expect(page).to have_content('não pode ficar em branco', count: 4)
    expect(page).to_not have_content('Produto anunciado com sucesso!')
    expect(page).to_not have_content('Anuncio')
    expect(page).to_not have_content('Anunciado por')
    expect(page).to_not have_content('Comentários')
  end

  scenario 'price must be greater than or equal to 0' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    product_category = ProductCategory.create!(name: 'Livros')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Anuncie aqui'
    fill_in 'Nome do Produto', with: 'Killing Defense at Bridge'
    select 'Livros', from: 'Categoria'
    fill_in 'Descrição', with: 'Livro em bom estado, Killing Defense at Bridge do Hugh Kelsey, leitura obrigatória para qualquer jogador querendo melhorar seu nível!'
    fill_in 'Preço de Venda', with: '-1'
    click_on 'Anunciar'

    expect(page).to have_content('Preço de Venda deve ser maior ou igual a 0')
    expect(page).not_to have_content('Produto anunciado com sucesso!')
    expect(page).to_not have_content('não pode ficar em branco')
  end

  scenario 'must fill in profile' do
    user = Collaborator.create!(email:'user@email.com', password:'123456')
    product_category = ProductCategory.create!(name: 'Livros')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Anuncie aqui'

    expect(page).to have_content('Para fazer um anúncio, você deve primeiro completar o seu perfil.')
    expect(page).to have_link('completar o seu perfil', href: edit_collaborator_path(user))
    expect(page).not_to have_content('Criando seu anúncio')
    expect(page).not_to have_content('Nome do Produto')
    expect(page).not_to have_content('Categoria')
    expect(page).not_to have_content('R$')
  end

  scenario 'from profile' do
    user = Collaborator.create!(email:'user@email.com', birth_date:Date.parse('08/08/1994'),
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', password:'123456')
    product_category = ProductCategory.create!(name: 'Livros')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Seus anúncios'
    click_on 'Anunciar'
    fill_in 'Nome do Produto', with: 'Killing Defense at Bridge'
    select 'Livros', from: 'Categoria'
    fill_in 'Descrição', with: 'Livro em bom estado, Killing Defense at Bridge do Hugh Kelsey, leitura obrigatória para qualquer jogador querendo melhorar seu nível!'
    fill_in 'Preço de Venda', with: '40'
    click_on 'Anunciar'

    expect(page).to have_content('Produto anunciado com sucesso!')
    expect(page).to have_content('Você é o dono deste produto')
    expect(page).to have_content('Killing Defense')
    expect(page).to have_content('Livro em bom estado, Killing Defense at Bridge do Hugh Kelsey, leitura obrigatória para qualquer jogador querendo melhorar seu nível!')
    expect(page).to have_content('R$ 40,00')
    expect(page).to have_content('Ninguém deixou nenhum comentário ainda.')
  end
end
