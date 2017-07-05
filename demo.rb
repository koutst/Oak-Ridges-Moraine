require './lib/01_sql_object'

class House  < SQLObject
  has_many :residents, class_name: :Human

  finalize!
end

class Human  < SQLObject
  self.table_name = 'humans'

  has_many :dogs, foreign_key: :owner_id
  belongs_to :house

  finalize!
end

class Dog < SQLObject
  belongs_to :owner, class_name: :Human

  has_one_through :home, :owner, :house

  finalize!
end
