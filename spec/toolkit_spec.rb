require_relative 'spec_helper'
  
describe 'rsc_percona::toolkit' do

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it "creates functions" do
    expect(chef_run).to run_bash('create functions')
  end
  
  it 'installs required packages' do
    expect(chef_run).to install_package('percona-toolkit')
  end

end