require 'rails_helper'

RSpec.describe Collaborator, type: :model do
  it 'Nome, cargo e setor não podem ficar em branco mas pode ser nil' do
    user = Collaborator.create(email: 'user@email.com', password: '123456')

    user.social_name = 'User'
    user.full_name = ''
    user.position = ''
    user.sector = ''
    user.valid?

    expect(user.errors[:social_name]).to_not include('não pode ficar em branco')
    expect(user.errors[:full_name]).to include('não pode ficar em branco')
    expect(user.errors[:position]).to include('não pode ficar em branco')
    expect(user.errors[:sector]).to include('não pode ficar em branco')
    expect(user.errors.count).to eq 3
  end
end
