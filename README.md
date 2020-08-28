# README

Projeto final da primeira parte do treinamento da
Treina Dev, turma 04

## Sobre o projeto

É um projeto individual onde deve-se criar uma
aplicação em Ruby on Rails que consiste em criar uma
plataforma Web para que pessoas de uma mesma empresa
possam anunciar, comprar e vender produtos entre si.

## Instalação

Foi usado o Rails 6.0.3.2 e o ruby 2.5.1, que podem ser
instalados de diversas formas.
Para ruby:
https://www.ruby-lang.org/en/documentation/installation/

Para rails:
https://guides.rubyonrails.org/getting_started.html

## Testes

O desenvolvimento deste projeto será fortemente ligado
a *testes*, e para isso foi especificado no Gemfile já
duas gems: rspec-rails e capybara
Ao rodar o comando *rspec* no terminal, espera-se que o
computador rode todos os testes escritos. A ideia é
fazer diversos testes para cada funcionalidade,
garantindo (ou tentando garantir) que a aplicação
funciona. Para rodar apenas um teste por vez, deve-se
escrever *rspec [caminho-do-arquivo]*, isso evita de
testar todas as funcionalidades, o que pode demorar
muito caso hajam muitos testes, quando o objetivo era
fazer um único teste específico.
Além disso, o comando *rspec [caminho-do-arquivo]:10*
vai rodar só o teste da linha 10 arquivo especificado
no caminho.
