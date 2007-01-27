require File.dirname(__FILE__) + '/spec_helper'

class Chicken < ActiveRecord::Base
  include InstanceValidations
end

context "A class with InstanceValidations mixed in" do
  setup do
    Chicken.stub!(:columns).and_return [Column.new("name", nil, "string", false)]
    @named_chicken = Chicken.new
    class << @named_chicken
      validates_presence_of :name
    end
    
    @chicken = Chicken.new
  end
  
  specify "should validate instances separately" do
    @named_chicken.should_have(1).error_on :name
    @chicken.should_be_valid
  end
end

class ExistingValidations < ActiveRecord::Base
  include InstanceValidations
  validates_presence_of :name
end

context "For a class with existing validations" do
  setup do
    ExistingValidations.stub!(:columns).and_return [Column.new("name", nil, "string", false),
                                                    Column.new("home_town", nil, "string", false)]
    @chicken = ExistingValidations.new
  end
  
  specify "instance validations should clear out the class validations" do
    class << @chicken
      validates_presence_of :home_town
    end
    
    @chicken.should_have(0).errors_on :name
    @chicken.should_have(1).error_on :home_town
  end
  
  specify "instances should default to the class validations" do
    @chicken.should_have(1).error_on :name
    @chicken.should_have(0).errors_on :home_town
  end
end
