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

    it 'should contain class ::postgresql::globals' do
      is_expected.to contain_class('postgresql::globals').with(
          'version'  => '9.3'
        )
    end

    it 'should contain class ::puppetdb::master::config' do
      is_expected.to contain_class('puppetdb::master::config').with(
          'puppet_service_name' => 'httpd',
          'terminus_package'    => 'puppetdb-terminus',
          'test_url'            => '/v3/version'
        )
    end

    it 'should contain class ::postgresql::server' do
      is_expected.to contain_class('postgresql::server')
    end

    it 'should contain package postgresql-server' do
      is_expected.to contain_package('postgresql-server').with(
           'version' => nil
        )
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

    it 'should contain class ::postgresql::globals' do
      is_expected.to contain_class('postgresql::globals').with(
          'version'  => nil
        )
    end

    it 'should contain class ::puppetdb::master::config' do
      is_expected.to contain_class('puppetdb::master::config').with(
          'puppet_service_name' => 'httpd',
          'terminus_package'    => 'puppetdb-terminus',
          'test_url'            => '/v3/version'
        )
    end

    it 'should contain class ::postgresql::server' do
      is_expected.to contain_class('postgresql::server')
    end

    it 'should contain package postgresql-server' do
      is_expected.to contain_package('postgresql-server').with(
           'version' => nil
        )
    end
  end
end
