require './lib/sql_object'
require './lib/searchable'
require './lib/associatable'
require './lib/db_connection'


DEMO_DB = 'dogs.db'
DEMO_SQL = 'dogs.sql'

`rm '#{DEMO_DB}'`
`cat '#{DEMO_SQL}' | sqlite3 '#{DEMO_DB}'`

DBConnection.open(DEMO_DB)


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
