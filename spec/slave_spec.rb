require_relative 'spec_helper'

describe 'rsc_percona::slave' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rs-mysql::slave')
  end
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['cloud']['public_ips'] = ['', '']
      node.set['cloud']['private_ips'] = ['10.0.2.15', '10.0.2.16']
      node.set['memory']['total'] = '1011228kB'
      node.set['rs-mysql']['application_database_name'] = 'apptest'
      node.set['rs-mysql']['backup']['lineage'] = 'testing'
      node.set['rs-mysql']['server_repl_password'] = 'replpass'
      node.set['rs-mysql']['server_root_password'] = 'rootpass'
    end.converge(described_recipe) 
  end
  
  it 'include rs-mysql::slave recipe' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rs-mysql::slave')
    chef_run
  end
  
end