require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = params.map{ |key, val| "#{key} = ?"}.join(" AND ")
    obj = DBConnection.execute(<<-SQL, params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL
    obj.map { |el| self.new(el)}
  end
end

class SQLObject
  extend Searchable
end
