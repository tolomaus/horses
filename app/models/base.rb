#module WhiteHorseFarm
#  module Model
    class Base < ActiveRecord::Base
      self.abstract_class = true

      include ActiveModel::Validations
      class DateValidator < ActiveModel::EachValidator
        def validate_each(record,attribute,value)
          record.errors[attribute] << "must be a valid datetime or blank" unless value.blank? or value.is_a?(ActiveSupport::TimeWithZone)
        end
      end
    end
#  end
#end