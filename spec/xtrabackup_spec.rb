require_relative 'spec_helper'

describe 'rsc_percona::xtrabackup' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rsc_percona')
  end
  
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe) 
  end
  
  it 'include recipe' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rsc_percona')
    chef_run
  end
  
  it 'installs required packages' do
    expect(chef_run).to install_package('percona-xtrabackup')
  end

end