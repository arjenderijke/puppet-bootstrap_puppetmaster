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

    it 'should not compile with missing resource' do
      expect {
        should_not compile.to raise_error(/Could not find resource 'Class[Apache::Mod::Prefork]' for relationship on 'Class[Apache::Mod::Cgi]'/)
      }
    end
  end
end
