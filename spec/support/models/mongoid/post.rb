class Post
  include Mongoid::Document
  include ActiveMongoid


  field :name

  belongs_to_record :player, foreign_key: :_player_id
  has_one_record :division
end
