require 'spec_helper'
describe 'bootstrap_puppetmaster::puppetdb' do

  context 'with defaults for all parameters on Fedora 21' do

    let(:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '21'
      }
    end

    it 'should contain class bootstrap_puppetmaster::puppetdb' do
      is_expected.to contain_class('bootstrap_puppetmaster::puppetdb')
    end

    it 'should contain class ::postgresql::server' do
      is_expected.to contain_class('postgresql::server')
    end

  end

  context 'with defaults for all parameters on Fedora 22' do

    let(:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '22'
      }
    end

    it 'should contain class bootstrap_puppetmaster::puppetdb' do
      expect {
        should contain_class('bootstrap_puppetmaster::puppetdb')
      }
    end
  end
end
