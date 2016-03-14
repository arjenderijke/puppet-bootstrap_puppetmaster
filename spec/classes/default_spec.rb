require 'spec_helper'
describe 'bootstrap_puppetmaster' do

  context 'with defaults for all parameters' do

    let(:facts) do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '21'
      }
    end

    it 'should contain class bootstrap_puppetmaster' do
      expect {
        should contain_class('bootstrap_puppetmaster')
      }
    end
  end
end
