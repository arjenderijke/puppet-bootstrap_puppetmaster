require 'spec_helper'
describe 'bootstrap_puppetmaster' do

  context 'with defaults for all parameters' do
    it { should contain_class('bootstrap_puppetmaster') }
  end
end
