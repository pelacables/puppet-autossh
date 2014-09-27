require 'spec_helper'

describe 'autossh', :type => :class  do

  let(:title) { 'init' }
  let :params do
    {
      :user             => 'someuser',
      :tunnel_type      => 'reverse',
      :port             => '22',
      :hostport         => '2000',
      :remote_ssh_host  => '123.123.123.1',
      :remote_ssh_port  => '22',
      :monitor_port     => '0',
      :enable           => true,
      :tunnel_name      => 'somename'
    }
  end

  context 'with defaults for all parameters' do
    it { should create_class('autossh') }
    it { should contain_package('autossh') }
    it { should contain_autossh__tunnel('somename').with(
      :user             => 'someuser',
      :tunnel_type      => 'reverse',
      :port             => '22',
      :hostport         => '2000',
      :remote_ssh_host  => '123.123.123.1',
      :remote_ssh_port  => '22',
      :monitor_port     => '0',
      :enable           => true
    ) }
  end
end
