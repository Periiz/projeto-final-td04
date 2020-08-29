require 'rails_helper'

#TODO colocar as traduções do devise e mudar esse teste pras formas traduzidas

feature 'Opening homepage' do
  scenario 'has to login' do
    visit root_path

    #expect(page).to have_content('Faça login para prosseguir')
    expect(page).to have_content('You need to sign in or sign up before continuing')
    expect(page).to have_content('Email')
    #expect(page).to have_content('Senha')
    expect(page).to have_content('Password')
    #expect(page).to have_content('Esqueci minha senha')
    expect(page).to have_content('Remember me')
    expect(page).to have_content('Sign up')
    expect(page).to have_content('Forgot your password?')
    expect(page).to have_content('Log in')
    #expect(page).to have_content('Entrar')
    expect(page).not_to have_content('Bem vindo ao Market Place!')
    expect(page).not_to have_content('Perfil')
    expect(page).not_to have_content('Busca')
  end

  scenario 'logged in' do
    Collaborator.create!(email: 'pessoa@email.com', password:'123456')

    visit root_path

    fill_in 'Email', with: 'pessoa@email.com'
    fill_in 'Password', with: '123456'
    check 'Remember me'
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully.')
    expect(page).to have_content('Market Place')
    expect(page).to have_content('Bem vindo ao Market Place, seu site corporativo de compra e venda')
    expect(page).to have_link('Perfil')
    expect(page).to have_link('Anuncie aqui')
    expect(page).to have_link('Sair', href: destroy_collaborator_session_path)
    expect(page).to have_content('Busca')
  end
end
