require "rubygems"
require "bundler"
Bundler.setup(:default, :test)

$:.unshift File.expand_path('../../lib/', __FILE__)
require 'active_support/testing/setup_and_teardown'
require 'live_activity'
require 'minitest/autorun'

#LiveActivity.config # touch config to load ORM, needed in some separate tests

require 'active_record'
require 'active_record/connection_adapters/sqlite3_adapter'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end

class Activity < ActiveRecord::Base
  include LiveActivity::Activity

  has_and_belongs_to_many :users

  activity :new_enquiry do
    actor        :User
    act_object   :Article
    act_target   :Volume
    #option       :description
  end

  activity :test_description do
    actor        :User
    act_object   :Article
    act_target   :Volume
    option       :description
  end

  activity :test_option do
    actor        :User
    act_object   :Article
    act_target   :Volume
    option       :country
  end

  activity :test_bond_type do
    actor        :User
    act_object   :Article
    act_target   :Volume
    bond_type    :global
  end

  activity :test_reverses_bond_type do
    actor        :User
    act_object   :Article
    act_target   :Volume
    bond_type    :global
    reverses     :test_bond_type
  end

end

class User < ActiveRecord::Base
  include LiveActivity::Actor

  has_and_belongs_to_many :activities

end

class Article < ActiveRecord::Base

end

class Volume < ActiveRecord::Base

end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migrator.migrate(File.expand_path('../migrations', __FILE__))
