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
      base.extend Authlogic::AuthenticatesMany::Base

      base.send :include, InstanceMethods
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
        :_id
      end

      def default_timezone
        :utc
      end

      #def with_scope(query)
        #query = where(query) if query.is_a?(Hash)
        #yield query
      #end

      def method_missing(name, *args)
        if name =~ /^find_by_(.+)/ && self.fields.has_key?($1)
          method = <<-METHOD
            def #{name}(#{$1})
              where(:#{$1} => #{$1}).first
            end
          METHOD
          instance_eval method, __FILE__, __LINE__

          send name, *args
        else
          super
        end
      end

    end

    module InstanceMethods
      def readonly?
        false
      end
    end

  end
end
