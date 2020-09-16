require 'rails_helper'

feature 'Collaborator edits profile' do
  scenario 'successfully' do
    user = Collaborator.create(email: 'user@email.com', password: '123456',
                              full_name: 'Usuário', social_name: 'Usuário',
                              position: 'C', sector: 'S', birth_date: '01/01/1000')

    login_as(user, scope: :collaborator)
    visit edit_collaborator_path(1)
    fill_in 'Nome Completo', with: 'Usuário Colaborador'
    fill_in 'Nome Social', with: 'User'
    fill_in 'Data de Nascimento', with: '19/09/1995'
    fill_in 'Cargo', with: 'Cargo'
    fill_in 'Setor', with: 'Setor'
    click_on 'Enviar'

    expect(page).to have_content('Perfil preenchido com sucesso!')
    expect(page).to have_content('User')
    expect(page).to have_content('Setor')
    expect(current_path).to eq collaborator_path(1)
  end

  scenario "cannot edit someone else's profile" do
    user = Collaborator.create(email: 'user@email.com', password: '123456',
                              full_name: 'Usuário Colaborador', social_name: 'User',
                              position: 'Cargo', sector: 'Setor', birth_date: '19/09/1995')
    Collaborator.create(email: 'another-user@email.com', password: '123456',
                        full_name: 'Outro Usuário', social_name: 'Another',
                        position: 'Cargo', sector: 'Setor', birth_date: '08/08/1994')

    login_as(user, scope: :collaborator)
    visit edit_collaborator_path(2)

    expect(page).to have_content('Você não tem permissão pra isso')
    expect(current_path).to eq root_path
  end
end
