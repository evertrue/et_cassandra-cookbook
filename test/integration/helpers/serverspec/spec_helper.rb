require 'serverspec'
require 'default_installation'
require 'opscenter_installation'
require 'rspec/shell/expectations'

set :backend, :exec

RSpec.configure do |c|
  c.include Rspec::Shell::Expectations
end
