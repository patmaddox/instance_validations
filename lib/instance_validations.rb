module InstanceValidations
  private
  
  def run_instance_validations(validation_method)
    validations = (class << self; self; end).read_inheritable_attribute(validation_method.to_sym) ||
                  self.class.read_inheritable_attribute(validation_method.to_sym)
    if validations.nil? then return end
    validations.each do |validation|
      if validation.is_a?(Symbol)
        self.send(validation)
      elsif validation.is_a?(String)
        eval(validation, binding)
      elsif validation_block?(validation)
        validation.call(self)
      elsif validation_class?(validation, validation_method)
        validation.send(validation_method, self)
      else
        raise(
          ActiveRecordError,
          "Validations need to be either a symbol, string (to be eval'ed), proc/method, or " +
          "class implementing a static validation method"
        )
      end
    end
  end

  public
  def self.included(receiver)
    receiver.send(:alias_method, :run_class_validations, :run_validations)
    receiver.send(:alias_method, :run_validations, :run_instance_validations)
  end
end
