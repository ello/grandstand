require 'rails_helper'

Rspec.describe AggregatedUser do

  it 'can have users added and removed' do
    AggregatedUser.clear
    expect(AggregatedUser.all).to be_empty
    AggregatedUser.add(42, 'archer')
    AggregatedUser.add(43, 'lana')
    users = AggregatedUser.all
    expect(users.map(&:username)).to     include('archer', 'lana')
    expect(users.map(&:id)).to           include(42, 43)
    lana = AggregatedUser.get('lana')
    expect(lana.id).to eq 43
    AggregatedUser.remove('lana')
    users = AggregatedUser.all
    expect(users.map(&:username)).not_to include('lana')
    expect(users.map(&:id)).not_to       include(43)
    expect(users.map(&:username)).to     include('archer')
    expect(users.map(&:id)).to           include(42)
    lana = AggregatedUser.get('lana')
    expect(lana).to eq nil
    AggregatedUser.clear
  end
end
