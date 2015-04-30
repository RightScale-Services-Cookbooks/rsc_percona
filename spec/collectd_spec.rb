require_relative 'spec_helper'

describe 'rsc_percona::collectd' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe) 
  end
  
  it 'include rs-mysql recipe' do
    expect(chef_run).to include_recipe('rs-mysql::collectd')
  end
  
end
