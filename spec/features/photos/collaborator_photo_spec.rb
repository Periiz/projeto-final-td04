require 'rails_helper'

feature 'Collaborator has profile pic' do
  scenario "and it's the default one" do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    login_as(seller, scope: :collaborator)
    visit root_path
    click_on 'Perfil'

    expect(page).to have_css('img[src*="default_avatar_0.png"]')
  end

  scenario 'and changes it' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')

    login_as(seller, scope: :collaborator)
    visit root_path
    click_on 'Perfil'
    click_on 'Editar'
    attach_file 'Foto', Rails.root.join('spec/support/capa-killing-defense.jpeg')
    click_on 'Enviar'

    expect(page).to have_css('img[src*="capa-killing-defense.jpeg"]')
  end
end
