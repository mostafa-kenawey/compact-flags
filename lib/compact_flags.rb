require "compact_flags/engine"

module CompactFlags
  module HasFlags
    MAX_FLAGS_MAPPING = 0xFFFFFFFF
    MAX_FLAGS_COUNT = 31

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def compact_flags(*args)
        mapping = args.first
        store_column = mapping.keys.first
        flags = mapping[store_column]

        raise "No flags defined" if flags.blank?
        raise "Too many flags, maximum flags count (#{MAX_FLAGS_COUNT})" if flags.size > MAX_FLAGS_COUNT

        @@flags ||={}
        @@store_columns ||={}
        i=0

        flags.each do |flag|
          @@flags[flag] = 1 << i
          @@store_columns[flag] = store_column
          i += 1

          # Define instance getter
          define_method "#{flag}" do
            return (@@flags[flag] & self.send(store_column)) > 0
          end

          alias_method "#{flag}?", "#{flag}"

          # Define instance setter
          define_method "#{flag}=" do |val|
            self.send("#{store_column}=", (val ?
                self.send(store_column) | @@flags[flag] :
                self.send(store_column) & (MAX_FLAGS_MAPPING ^ @@flags[flag]) ))
          end

          # named scopes to be used in conditions
          scope "#{flag}".pluralize.to_sym, -> {where("(#{@@store_columns[flag]} & #{@@flags[flag]}) > 0")}
          scope "not_#{flag}".pluralize.to_sym, -> {where("(#{@@store_columns[flag]} & #{@@flags[flag]}) = 0")}
        end

        class << self
          @@flags.each do |key, value|
            define_method "#{key}_value" do
              return value
            end

            define_method "where_#{key}" do
              return "(#{@@store_columns[key]} & #{@@flags[key]}) > 0"
            end

            define_method "where_not_#{key}" do
              return "(#{@@store_columns[key]} & #{@@flags[key]}) = 0"
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, CompactFlags::HasFlags
