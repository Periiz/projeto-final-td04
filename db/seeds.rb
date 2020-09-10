# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

ProductCategory.create(name: 'Outros')
livros = ProductCategory.create(name: 'Livros')
eletro = ProductCategory.create(name: 'Eletrônicos')
ProductCategory.create(name: 'Roupas')

joao = Collaborator.create(email: 'joao@email.com', password: '123456', social_name: 'João',
                    full_name: 'João de Testes', position: 'Cargo',
                    sector: 'RH', birth_date: Date.parse('08/08/1994'))
lucas = Collaborator.create(email: 'lucas@email.com', password: '123456', social_name: 'Perez',
                    full_name: 'Lucas Perez', position: 'Junior',
                    sector: 'SSN', birth_date: Date.parse('19/09/1995'))
marina = Collaborator.create(email: 'marina@email.com', password: '123456', social_name: 'Marina',
                    full_name: 'Marina de Testes', position: 'CEO',
                    sector: 'Adm', birth_date: Date.parse('03/10/1973'))

kd = Product.create(name: 'Killing Defence at Bridge', product_category: livros,
               description: 'Do Hugh Kelsey, um excelente livro para quem quer melhorar o seu ataque! :D',
               sale_price: 75, collaborator: marina)
kd.photos.attach(io: File.open(Rails.root.join('spec/support/capa-killing-defense.jpeg')),
                 filename: 'capa-killing-defense.jpeg', content_type:'image/jpeg')
kd.photos.attach(io: File.open(Rails.root.join('spec/support/costas-killing-defense.jpeg')),
                 filename: 'costas-killing-defense.jpeg', content_type:'image/jpeg')
Comment.create(text: 'Este livro é usado? Você tem também o More Killing Defence? õ.ô',
               product: kd, post_date: DateTime.current-1, collaborator: lucas)
Comment.create(text: 'Sim, é um pouco usado, principalmente nas pontas dá pra ver o desgaste, mas está em ótimo estado. Não tenho o More Killing Defence :(',
                product: kd, post_date: DateTime.current, collaborator: marina)

jbl = Product.create(name: 'Caixa de som JBL', product_category: eletro,
                    description: 'Caxinha quase nova, estou vendendo :)',
                    sale_price: 200, collaborator: joao)
jbl.photos.attach(io: File.open(Rails.root.join('spec/support/jbl-lado.png')),
                  filename: 'jbl-lado.png', content_type:'image/png')
jbl.photos.attach(io: File.open(Rails.root.join('spec/support/jbl-pe.png')),
                  filename: 'jbl-pe.png', content_type:'image/png')

rb = Product.create(name: 'A Revolução dos Bichos', product_category: livros,
                    description: 'Um clássico!', sale_price: 50, collaborator: lucas)
rb.photos.attach(io: File.open(Rails.root.join('spec/support/a-revolucao-dos-bichos.jpg')),
                  filename: 'a-revolucao-dos-bichos', content_type:'image/jpg')
