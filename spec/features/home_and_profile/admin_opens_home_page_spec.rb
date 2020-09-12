require 'rails_helper'

feature 'Admin opens home page' do
  scenario 'and is in admin view' do
    admin = Collaborator.create(email: 'admin@email.com', password: '123456', admin: true)

    login_as(admin, scope: :collaborator)
    visit root_path

    #TODO Fazer esse teste quando tiver coisas diferentes pro admin!
    expect(page).to have_content('Ainda não tem páginas do admin')
    expect(page).to_not have_content('Bem vindo')
  end
end
