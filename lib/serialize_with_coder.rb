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
            if instance_variable_get("@#{attr_name}_rchanged")
              instance_variable_set("@#{attr_name}_rchanged", nil)
              true
            else
              class_name.load( read_attribute(attr_name) ) != send(attr_name)
            end
          end

          define_method("#{attr_name}_change") do
            send("#{attr_name}_changed?") ? [send("#{attr_name}_was"), send(attr_name)] : nil
          end

          define_method("#{attr_name}_was") do
            class_name.load( read_attribute(attr_name) )
          end
        end
      else
        raise "There is no column named #{attr_name}!"
      end

      define_method("synchronize_serialized_fields") do
        @@serialized_with_coder_fields.each do |column, coder|
          if send("#{column}_changed?")
            write_attribute(column, coder.dump( instance_variable_get("@#{column}") ))
            instance_variable_set("@#{column}_rchanged", true)
          end
        end
      end

    end
  end
end

ActiveRecord::Base.extend(SerializeWithCoder::ClassMethods)
