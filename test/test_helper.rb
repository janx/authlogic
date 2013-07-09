require "test/unit"
require "rubygems"
require "timecop"
require "i18n"
require 'mongoid'

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

  private

    def users(name)
      salt = Authlogic::Random.hex_token

      case name
      when :ben
        User.create!(
          company: 'binary_logic',
          projects: 'web_services',
          login: 'bjohnson',
          password_salt: salt,
          crypted_password: Authlogic::CryptoProviders::Sha512.encrypt("benrocks" + salt),
          persistence_token: '6cde0674657a8a313ce952df979de2830309aa4c11ca65805dd00bfdc65dbcc2f5e36718660a1d2e68c1a08c276d996763985d2f06fd3d076eb7bc4d97b1e317',
          single_access_token: Authlogic::Random.friendly_token,
          perishable_token: Authlogic::Random.friendly_token,
          email: 'bjohnson@binarylogic.com',
          first_name: 'Ben',
          last_name: 'Johnson' )
      when :zack
        User.create!(
          company: 'logic_over_data',
          projects: 'web_services',
          login: 'zackham',
          password_salt: salt,
          crypted_password: Authlogic::CryptoProviders::Sha512.encrypt("zackrocks" + salt),
          persistence_token: 'fd3c2d5ce09ab98e7547d21f1b3dcf9158a9a19b5d3022c0402f32ae197019fce3fdbc6614d7ee57d719bae53bb089e30edc9e5d6153e5bc3afca0ac1d320342',
          single_access_token: Authlogic::Random.friendly_token,
          email: 'zham@ziggityzack.com',
          first_name: 'Zack',
          last_name: 'Ham' )
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
