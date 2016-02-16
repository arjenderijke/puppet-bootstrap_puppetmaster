require 'spec_helper'
describe 'bootstrap_puppetmaster' do

  context 'with defaults for all parameters' do

    let(:facts) do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04'
      }
      
    it { should contain_class('bootstrap_puppetmaster') }
  end
end
