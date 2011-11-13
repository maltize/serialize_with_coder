module SerializeWithCoder

  module ClassMethods

    def serialize_with_coder(attr_name, class_name)
      self.class_eval do
        @@serialized_with_coder_fields ||= {}
        @@serialized_with_coder_fields.merge!(
          attr_name => class_name
        )

        before_save :synchronize_serialized_fields

        define_method("reload_serialized_fields") do
          @@serialized_with_coder_fields.each do |column, coder|
            instance_variable_set("@#{column}", nil)
          end
        end

        define_method("reload") do |*options|
          reload_serialized_fields
          super(options)
        end
      end

      if column_names.include?(attr_name.to_s)
        self.class_eval do
          define_method("#{attr_name}=") do |val|
            instance_variable_set("@#{attr_name}", val)
          end

          define_method(attr_name) do
            instance_variable_get("@#{attr_name}") ?
              instance_variable_get("@#{attr_name}") :
              instance_variable_set("@#{attr_name}", class_name.load( read_attribute(attr_name) ))
          end

          define_method("#{attr_name}_changed?") do
            class_name.load( read_attribute(attr_name) ) != send(attr_name)
          end
        end
      else
        raise "There is no column named #{attr_name}!"
      end

      define_method("attribute_for_inspect") do |attr_name|
        value = @@serialized_with_coder_fields[attr_name.to_sym] ?
          send(attr_name) :
          read_attribute(attr_name)

        if value.is_a?(String) && value.length > 50
          "#{value[0..50]}...".inspect
        elsif value.is_a?(Date) || value.is_a?(Time)
          %("#{value.to_s(:db)}")
        else
          value.inspect
        end
      end

      define_method("synchronize_serialized_fields") do
        @@serialized_with_coder_fields.each do |column, coder|
          write_attribute(column, coder.dump( instance_variable_get("@#{column}") )) if send("#{column}_changed?")
        end
      end

    end
  end
end

ActiveRecord::Base.extend(SerializeWithCoder::ClassMethods)