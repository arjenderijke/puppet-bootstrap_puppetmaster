require 'spec_helper'
describe 'bootstrap_puppetmaster' do

  context 'with defaults for all parameters' do

    let(:facts) do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04'
      }
    end

    #t { should contain_class('bootstrap_puppetmaster') }
    it { should_not compile.and_raise_error(Puppet::Error, /Could not find resource 'Class[Apache::Mod::Prefork]' for relationship on 'Class[Apache::Mod::Cgi]'/) }
  end
end
