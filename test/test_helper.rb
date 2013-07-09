require "test/unit"
require "rubygems"
require "timecop"
require "i18n"
require 'mongoid'

$: << File.expand_path('../../lib', __FILE__)

I18n.load_path << File.dirname(__FILE__) + '/i18n/lol.yml'

Mongoid.load! File.expand_path('../mongoid.yml', __FILE__), 'test'

logger = Logger.new(STDOUT)
logger.level= Logger::FATAL

require File.dirname(__FILE__) + '/../lib/authlogic' unless defined?(Authlogic)
require File.dirname(__FILE__) + '/../lib/authlogic/test_case'
require File.dirname(__FILE__) + '/libs/project'
require File.dirname(__FILE__) + '/libs/affiliate'
require File.dirname(__FILE__) + '/libs/employee'
require File.dirname(__FILE__) + '/libs/employee_session'
require File.dirname(__FILE__) + '/libs/ldaper'
require File.dirname(__FILE__) + '/libs/user'
require File.dirname(__FILE__) + '/libs/user_session'
require File.dirname(__FILE__) + '/libs/company'

Authlogic::CryptoProviders::AES256.key = "myafdsfddddddddddddddddddddddddddddddddddddddddddddddd"

class ActiveSupport::TestCase
  #self.fixture_path = File.dirname(__FILE__) + "/fixtures"
  #self.use_transactional_fixtures = false
  #self.use_instantiated_fixtures  = false
  #self.pre_loaded_fixtures = false
  #fixtures :all
  setup :activate_authlogic

  setup do
    Project.delete_all
    Company.delete_all
    User.delete_all
    Employee.delete_all
  end

  private

    def find_or_create_fixture(klass, key, attrs)
      exist = klass.where(key => attrs[key]).first
      exist || klass.create!(attrs)
    end

    def projects(name)
      case name
      when :web_services
        Project.where(name: 'web services').first_or_create!
      end
    end

    def companies(name)
      case name
      when :binary_logic
        Company.where(name: 'Binary Logic').first_or_create!
      when :logic_over_data
        Company.where(name: 'Logic Over Data').first_or_create!
      end
    end

    def employees(name)
      salt = Authlogic::Random.hex_token

      case name
      when :drew
        find_or_create_fixture(Employee, :email,
          company: companies(:binary_logic),
          email: 'dgainor@binarylogic.com',
          password: "1234567",
          password_confirmation: "1234567",
          first_name: 'Drew',
          last_name: 'Gainor')
      when :jennifer
        find_or_create_fixture(Employee, :email,
          company: companies(:logic_over_data),
          email: 'jjohnson@logicoverdata.com',
          password: "1234567",
          password_confirmation: "1234567",
          first_name: 'Jennifer',
          last_name: 'Johnson')
      end
    end

    def users(name)
      case name
      when :ben
        find_or_create_fixture(User, :login,
          company: companies(:binary_logic),
          projects: [projects(:web_services)],
          login: 'bjohnson',
          password: "benrocks",
          password_confirmation: "benrocks",
          email: 'bjohnson@binarylogic.com',
          first_name: 'Ben',
          last_name: 'Johnson')
      when :zack
        find_or_create_fixture(User, :login,
          company: companies(:logic_over_data),
          projects: [projects(:web_services)],
          login: 'zackham',
          password: "1234567",
          password_confirmation: "1234567",
          email: 'zham@ziggityzack.com',
          first_name: 'Zack',
          last_name: 'Ham')
      end
    end

    def password_for(user)
      case user
      when users(:ben)
        "benrocks"
      when users(:zack)
        "zackrocks"
      end
    end

    def http_basic_auth_for(user = nil, &block)
      unless user.blank?
        controller.http_user = user.login
        controller.http_password = password_for(user)
      end
      yield
      controller.http_user = controller.http_password = controller.realm = nil
    end

    def set_cookie_for(user, id = nil)
      controller.cookies["user_credentials"] = {:value => user.persistence_token, :expires => nil}
    end

    def unset_cookie
      controller.cookies["user_credentials"] = nil
    end

    def set_params_for(user, id = nil)
      controller.params["user_credentials"] = user.single_access_token
    end

    def unset_params
      controller.params["user_credentials"] = nil
    end

    def set_request_content_type(type)
      controller.request_content_type = type
    end

    def unset_request_content_type
      controller.request_content_type = nil
    end

    def set_session_for(user, id = nil)
      controller.session["user_credentials"] = user.persistence_token
      controller.session["user_credentials_id"] = user.id
    end

    def unset_session
      controller.session["user_credentials"] = controller.session["user_credentials_id"] = nil
    end
end

#require 'pry'
#binding.pry
