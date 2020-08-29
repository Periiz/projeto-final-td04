require 'rails_helper'

feature 'Collaborator fills profile' do
  scenario 'successfully' do
    user = Collaborator.create!(email:'user@email.com', password:'123456')

    visit root_path
    #TODO entender por que o comando login_as não ta funcionando
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Login'
    #############################################################
    click_on 'Preencha o seu perfil agora!'
    fill_in 'Nome Completo', with: 'Usuário Colaborador'
    fill_in 'Nome Social', with: 'User'
    fill_in 'Data de Nascimento', with: '19/09/1995'
    fill_in 'Cargo', with: 'Um Cargo'
    fill_in 'Setor', with: 'Um Setor'
    click_on 'Enviar'

    puts "============"
    puts user.full_name

    expect(page).to have_content('Perfil preenchido com sucesso!')
    #TODO fazer o capybara procurar o negócio vermelho
    #expect(page).to_not have_css('style="color:red"', text: 'Perfil')
  end
end
