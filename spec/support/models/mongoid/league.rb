class League
  include Mongoid::Document
  include ActiveMongoid
  include Mongoid::JSON

  field :name

  has_one_record :division
  has_one_record :division_setting, class_name: "Settings::DivisionSetting"
end
