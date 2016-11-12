module Eatl
  class Schema
    class Field
      def initialize(field_attributes)
        @field_attributes = field_attributes
      end

      def name
        @field_attributes['name']
      end

      def type
        @field_attributes['type'].to_s.downcase
      end

      def xpath
        @field_attributes['xpath']
      end

      def node?
        @field_attributes.has_key?('node')
      end

      def children
        Array[*@field_attributes['children']].map { |f| Field.new(f) }
      end
    end

    def initialize(schema_hash)
      @schema = schema_hash
    end

    def input_fields
      @input_fields ||= @schema.fetch('input_fields').map { |f| Field.new(f) }
    end

    def name
      @schema.fetch('name', 'schema')
    end

    def to_struct
      Struct.new(constant_name, *field_names)
    end

    private

    def constant_name
      constantize(name)
    end

    def field_names
      input_fields.select(&:name).
        concat(input_fields.flat_map(&:children)).
        map { |f| f.name.to_sym }
    end

    def constantize(underscore_name)
      underscore_name.split('_').map(&:capitalize).join
    end

  end
end
