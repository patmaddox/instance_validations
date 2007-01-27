plugin_spec_dir = File.dirname(__FILE__)
require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")
Column = ActiveRecord::ConnectionAdapters::Column