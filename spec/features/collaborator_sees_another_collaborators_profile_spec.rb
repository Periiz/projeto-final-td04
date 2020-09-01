require 'rails_helper'

feature "Collaborator sees another collaborator's profile" do
  scenario 'with profile already filled' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    another_user = Collaborator.create!(email:'another@email.com', password:'098765',
                                        full_name:'Outra Pessoa', social_name: 'Vendedor Teste',
                                        position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    login_as(user, scope: :collaborator)
    visit collaborator_path(another_user)

    expect(page).to have_content("Você está visitando o perfil de #{another_user.name}")
    expect(page).to have_content('Vocês são da mesma empresa! Vocês podem fazer negociações entre si!')
    expect(page).to have_content(another_user.full_name)
    expect(page).to have_content(another_user.email)
    expect(page).to have_content(another_user.sector)
    expect(page).to have_content(another_user.position)
    expect(page).to have_content('Anúncios')
    expect(page).to have_content("Você não tem nenhuma negociação pendente com #{another_user.name}")
    expect(page).to have_link('Home Page', href: root_path)
  end

  scenario 'with profile not filled' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    another_user = Collaborator.create!(email:'another@email.com', password:'098765')

    login_as(user, scope: :collaborator)
    visit collaborator_path(another_user)

    expect(page).to have_content('Este perfil ainda não está completamente preenchido...')
    expect(page).to have_content(another_user.email)
  end

  scenario 'with profile partially filled' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    another_user = Collaborator.create!(email:'another@email.com', password:'098765',
                                        full_name:'Outra Pessoa',
                                        position: 'Cargo', sector: 'Setor')

    login_as(user, scope: :collaborator)
    visit collaborator_path(another_user)

    expect(page).to have_content('Este perfil ainda não está completamente preenchido...')
    expect(page).to have_content(another_user.email)
    expect(page).to have_content(another_user.name)
    expect(page).to have_content(another_user.position)
    expect(page).to have_content(another_user.sector)
  end

  scenario 'from another company' do
    user = Collaborator.create!(email:'user@email.com', password:'123456',
                                full_name:'Usuário Colaborador', social_name: 'User',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    another_user = Collaborator.create!(email:'another@different-email.com', password:'098765',
                                        full_name:'Outra Pessoa', social_name: 'Vendedor Teste',
                                        position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    login_as(user, scope: :collaborator)
    visit collaborator_path(another_user)

    expect(page).to have_content('Só é possível ver o perfil de colaboradores que são da mesma empresa que você...')
    expect(page).to_not have_content("Você está visitando o perfil de #{another_user.name}")
    expect(page).to_not have_content('Vocês são da mesma empresa! Vocês podem fazer negociações entre si!')
    expect(page).to_not have_content(another_user.full_name)
    expect(page).to_not have_content(another_user.email)
    expect(page).to_not have_content(another_user.sector)
    expect(page).to_not have_content(another_user.position)
    expect(page).to_not have_content('Anúncios')
  end
end