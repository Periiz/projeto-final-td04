require 'rails_helper'

feature 'Collaborator fills profile' do
  scenario 'before filling' do
    user = Collaborator.create(email:'user@email.com', password:'123456')

    login_as(user, scope: :collaborator)
    visit collaborator_path(user)

    expect(page).to have_content('Editar informações')
    expect(page).to have_content('Para que você possa anunciar')
  end

  scenario 'successfully' do
    user = Collaborator.create(email:'user@email.com', password:'123456')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Editar informações'
    fill_in 'Nome Completo', with: 'Usuário Colaborador'
    fill_in 'Nome Social', with: 'User'
    fill_in 'Data de Nascimento', with: '19/09/1995'
    fill_in 'Cargo', with: 'Um Cargo'
    fill_in 'Setor', with: 'Um Setor'
    click_on 'Enviar'

    expect(page).to have_content('Perfil preenchido com sucesso!')
    expect(page).to have_content('Seus anúncios')
    #TODO Fazer o capybara procurar o negócio vermelho nos dois cenários!
    #expect(page).to_not have_css('style=color:red')
  end

  scenario 'did not fill all the profile fields correctly' do
    user = Collaborator.create(email:'user@email.com', password:'123456')

    login_as(user, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Editar informações'
    click_on 'Enviar'

    expect(page).to have_content('não pode ficar em branco', count: 4)
    expect(page).not_to have_content('Perfil preenchido com sucesso!')
    expect(page).not_to have_content('Seus anúncios')
  end
end
