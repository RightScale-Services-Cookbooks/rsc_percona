require_relative 'spec_helper'

describe 'rsc_percona::volume' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rs-mysql::volume')
  end
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe) 
  end
  
  it 'include rs-mysql recipe' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rs-mysql::volume')
    chef_run
  end
  
end

