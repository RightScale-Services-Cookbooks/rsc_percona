require 'spec_helper'

describe 'rsc_percona::default' do
  
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rs-mysql::default')
  end

  let(:chef_run_ubuntu) { ChefSpec::Runner.new(platform: 'ubuntu',version: '14.04').converge(described_recipe) }
  let(:chef_run_centos) { ChefSpec::Runner.new(platform: 'centos', version: '6.5').converge(described_recipe) }

  it 'should have packages attributes' do
    expect(chef_run_ubuntu.node['mysql']['client']['packages']).to eq [ 'Percona-Server-client-5.6','libmysqlclient-dev']
    expect(chef_run_ubuntu.node['mysql']['server']['packages']).to eq ['Percona-Server-server-5.6']
  end
  
  it 'should have packages attributes' do
    expect(chef_run_centos.node['mysql']['client']['packages']).to eq [ 'Percona-Server-client-56','Percona-Server-devel-56']
    expect(chef_run_centos.node['mysql']['server']['packages']).to eq ['Percona-Server-server-56','Percona-Server-devel-56','Percona-Server-shared-56']
  end

  it "should have version node" do
    expect(chef_run_centos.node['mysql']['server']['service_name']).to eq 'mysql'
    expect(chef_run_centos.node['mysql']['version']).to eq "5.6"
  end
  
  it "setup apt repos" do
    expect(chef_run_ubuntu).to include_recipe("apt")
    expect(chef_run_ubuntu).to add_apt_preference("00percona.pref")
    expect(chef_run_ubuntu).to add_apt_repository("percona")
    expect(chef_run_ubuntu).to run_execute("apt-get update")
  end
  
  it "setup yum repos" do
    expect(chef_run_centos).to include_recipe("yum")
    expect(chef_run_centos).to create_yum_repository("percona")
    expect(chef_run_centos).to_not run_execute("create-yum-cache")
    expect(chef_run_centos).to_not run_ruby_block("reload-internal-yum-cache")
    resource = chef_run_centos.find_resource("yum_repository", "percona")
    expect(resource).to notify('execute[create-yum-cache]').to(:run).immediately
    expect(resource).to notify('ruby_block[reload-internal-yum-cache]').to(:create).immediately
  end

  it 'include rs-mysql recipe' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rs-mysql::default')
    chef_run_centos
  end
  
  it 'include rs-mysql recipe' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rs-mysql::default')
    chef_run_ubuntu
  end
end