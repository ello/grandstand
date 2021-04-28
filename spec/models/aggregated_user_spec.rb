# frozen_string_literal: true

require 'rails_helper'

Rspec.describe AggregatedUser do

  it 'can have users added and removed' do
    described_class.clear
    expect(described_class.all).to be_empty
    described_class.add(42, 'archer')
    described_class.add(43, 'lana')
    users = described_class.all
    expect(users.map(&:username)).to     include('archer', 'lana')
    expect(users.map(&:id)).to           include(42, 43)
    lana = described_class.get('lana')
    expect(lana.id).to eq 43
    described_class.remove('lana')
    users = described_class.all
    expect(users.map(&:username)).not_to include('lana')
    expect(users.map(&:id)).not_to       include(43)
    expect(users.map(&:username)).to     include('archer')
    expect(users.map(&:id)).to           include(42)
    lana = described_class.get('lana')
    expect(lana).to eq nil
    described_class.clear
  end
end
