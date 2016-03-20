require 'spec_helper'
describe 'bootstrap_puppetmaster::puppetmaster' do

  context 'with defaults for all parameters on Fedora 21' do

    let(:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '21'
      }
    end

    it 'should contain class bootstrap_puppetmaster::puppetmaster' do
      expect {
        should contain_class('bootstrap_puppetmaster::puppetmaster')
      }
    end

    it 'should contain class apache' do
      expect {
        should contain_class('apache')
      }
    end

    it 'should contain class apache::mod::passenger' do
      expect {
        should contain_class('apache::mod::passenger')
      }
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

    it 'should contain class bootstrap_puppetmaster::puppetmaster' do
      expect {
        should contain_class('bootstrap_puppetmaster::puppetmaster')
      }
    end

    it 'should contain class apache' do
      expect {
        should contain_class('apache')
      }
    end

    it 'should contain class apache::mod::passenger' do
      is_expected.to contain_class('apache::mod::passenger')
    end

    it 'should contain class apache::mod::proxy' do
      is_expected.to contain_class('apache::mod::proxy').with(
                 'proxy_requests' => 'On',
                 'allow_from'     => ['127.0.0.1', '192.168.121.0/24']
               )
    end
  end
end
