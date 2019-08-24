# frozen_string_literal: true

module Boyutluseyler
  module Utils
    module StrongMemoize
      def strong_memoize(name)
        if instance_variable_defined?(ivar(name))
          instance_variable_get(ivar(name))
        else
          instance_variable_set(ivar(name), yield)
        end
      end

      def clear_memoization(name)
        remove_instance_variable(ivar(name)) if instance_variable_defined?(ivar(name))
      end

      private

      def ivar(name)
        "@#{name}"
      end
    end
  end
end
