require 'rails_helper'

feature 'Collaborator makes comment on product page' do
  scenario 'successfully' do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    commenter = Collaborator.create(email:'commenter@email.com', password:'098765',
                                full_name:'Usuário Comentador', social_name: 'Chato',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller)

    login_as(commenter, scope: :collaborator)
    visit product_path(product.id)
    fill_in 'Deixe seu comentário', with: 'Um comentário'
    click_on 'Enviar'

    #OPTIMIZE Usar aquele Time Helpers não sei o quê pra congelar o tempo
    #OPTIMIZE e não fazer um teste que pode quebrar na virada do dia
    data = DateTime.current
    expect(page).to have_content(commenter.name)
    expect(page).to have_content(commenter.sector)
    expect(page).to have_content(data.strftime("%d/%m/") + data.year.to_s)
    expect(page).to have_content('Um comentário')
  end

  scenario "can't comment on sold product" do
    seller = Collaborator.create(email:'seller@email.com', password:'123456',
                                full_name:'Usuário Vendedor', social_name: 'Seller',
                                position: 'Cargo', sector: 'Setor', birth_date:'08/08/1994')
    commenter = Collaborator.create(email:'commenter@email.com', password:'098765',
                                full_name:'Usuário Comentador', social_name: 'Chato',
                                position: 'Cargo', sector: 'Setor', birth_date:'01/01/1997')

    product_category = ProductCategory.create(name: 'Livros')
    product = Product.create(name: 'Killing Defense, Hugh Kelsey', product_category: product_category,
                            description: 'Bom livro', sale_price: 40, collaborator: seller, status: :sold)
    negotiation = Negotiation.create(product: product, collaborator: commenter,
                                     seller_id: seller.id, status: :sold)

    login_as(commenter)
    visit product_path(product)

    expect(page).to_not have_content('Enviar')
  end
end
