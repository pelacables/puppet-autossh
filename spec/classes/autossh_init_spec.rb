require 'spec_helper'

describe 'autossh', :type => :class  do

  let(:title) { 'init' }

  #
  # Test that an error is raised on unsupported systems
  #
  context 'On Unsupported OS' do
    let(:facts) {{ :osfamily => 'UNKNOWN' }}
  
    it { 
      expect { should raise_error(Puppet::Error) } 
    }
  end  


  #
  # test that an error IS raised on unsupported systems (RHEL7)
  #
  context 'On Unsupported RedHat based OS' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '7' }}
    
    it { 
      expect { should raise_error(Puppet::Error) } 
    }

  end

  #
  # test that an error IS NOT raised on supported systems (RHEL6)
  #
  context 'On Supported RedHat based OS' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '6' }}
    
    it { 
      should contain_class('autossh')
    }

  end

  #
  # test default values
  #
  context 'test default values' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '6' }}
    
    it { 
      should contain_class('autossh')
      should contain_class('autossh::install')
      should contain_class('autossh::params')
      should contain_user('autossh')
      should contain_package('autossh')
      should contain_package('openssh-clients')
      should contain_package('redhat-lsb-core')
      should contain_file('/var/tmp/autossh-1.4d-3.el6.x86_64.rpm')
    }

  end


end
