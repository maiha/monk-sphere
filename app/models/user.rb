class User < Ohm::Model
  attribute :login
  attribute :pass

  index :login
end
