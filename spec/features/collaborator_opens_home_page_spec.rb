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
    Collaborator.create!(email: 'pessoa@email.com', password:'123456')

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
    user = Collaborator.create!(email:'user@email.com', password:'123456')

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
end
