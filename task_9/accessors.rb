# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}"
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=") do |value|
        instance_variable_set(var_name, value)
        @history ||= {}
        @history[name] ||= []
        @history[name] << value
      end
      define_method("#{name}_history") { @history }
    end
  end

  def strong_attr_accessor(name, class_name)
    var_name = "@#{name}"
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=") do |value|
      raise 'Не верный тип' if value.is_a?(class_name)

      instance_variable_set(var_name, class_name)
    end
  end
end
