module Authlogic
  module Mongoid

    def self.included(base)
      base.send :include, Authlogic::ActsAsAuthentic::Base
      base.send :include, Authlogic::ActsAsAuthentic::Email
      base.send :include, Authlogic::ActsAsAuthentic::LoggedInStatus
      base.send :include, Authlogic::ActsAsAuthentic::Login
      base.send :include, Authlogic::ActsAsAuthentic::MagicColumns
      base.send :include, Authlogic::ActsAsAuthentic::Password
      base.send :include, Authlogic::ActsAsAuthentic::PerishableToken
      base.send :include, Authlogic::ActsAsAuthentic::PersistenceToken
      base.send :include, Authlogic::ActsAsAuthentic::RestfulAuthentication
      base.send :include, Authlogic::ActsAsAuthentic::SessionMaintenance
      base.send :include, Authlogic::ActsAsAuthentic::SingleAccessToken
      base.send :include, Authlogic::ActsAsAuthentic::ValidationsScope

      base.extend ClassMethods
    end

    module ClassMethods
      def column_names
        fields.map &:first
      end

      def quoted_table_name
        collection_name
      end

      def primary_key
        # FIXME: Is this check good enough?
        if caller.first.to_s =~ /(persist|session)/
          :_id
        else
          @@primary_key
        end
      end

      def default_timezone
        :utc
      end

      #def find_by__id(*args)
        #find *args
      #end

      # Change this to your preferred login field
      #def find_by_username(username)
        #where(:username => username).first
      #end

      #def with_scope(query)
        #query = where(query) if query.is_a?(Hash)
        #yield query
      #end
    end

  end
end
