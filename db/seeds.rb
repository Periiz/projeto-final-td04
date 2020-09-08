# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ProductCategory.create(name: 'Outros')
ProductCategory.create(name: 'Livros')
ProductCategory.create(name: 'Eletrônicos')
ProductCategory.create(name: 'Roupas')
Collaborator.create(email:'vendedor@email.com', password:'123456', social_name: 'Vendedor Teste',
                    full_name:'Usuário Vendedor de Teste', position: 'Cargo',
                    sector: 'Setor', birth_date: Date.parse('08/08/1994'))
