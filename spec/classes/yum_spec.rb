require 'spec_helper'
describe 'bootstrap_puppetmaster::yum' do

  context 'with defaults for all parameters on Fedora 21' do

    let(:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '21'
      }
    end

    it 'should contain class bootstrap_puppetmaster::yum' do
      is_expected.to contain_class('bootstrap_puppetmaster::yum')
    end

    it 'should contain yumrepo puppetlabs-products' do
      is_expected.to contain_yumrepo('puppetlabs-products').with(
          'enabled'  => '1',
          'gpgcheck' => '0'
        )
    end

    it 'should contain yumrepo puppetlabs-deps' do
      is_expected.to contain_yumrepo('puppetlabs-deps').with(
          'enabled'  => '1',
          'gpgcheck' => '0'
        )
    end

    it 'should contain yumrepo puppetlabs-devel' do
      is_expected.to contain_yumrepo('puppetlabs-devel').with(
          'enabled'  => '1',
          'gpgcheck' => '0'
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

    it 'should contain class bootstrap_puppetmaster::yum' do
      is_expected.to contain_class('bootstrap_puppetmaster::yum')
    end

    it 'should contain yumrepo puppetlabs-products' do
      is_expected.to contain_yumrepo('puppetlabs-products').with(
          'enabled'  => '1',
          'gpgcheck' => '0'
        )
    end

    it 'should contain yumrepo puppetlabs-deps' do
      is_expected.to contain_yumrepo('puppetlabs-deps').with(
          'enabled'  => '1',
          'gpgcheck' => '0'
        )
    end

    it 'should contain yumrepo puppetlabs-devel' do
      is_expected.to contain_yumrepo('puppetlabs-devel').with(
          'enabled'  => '1',
          'gpgcheck' => '0'
        )
    end
  end
end
