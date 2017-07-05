require_relative 'db_connection'
require 'active_support/inflector'


class SQLObject
  def self.columns
    table = self.table_name
    # debugger
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{table}"
    SQL
    @columns.first.map{ |el| el.to_sym }
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        self.attributes[column]
      end
      define_method("#{column}=".to_sym) do |value|
        self.attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= "#{self}".tableize
  end

  def self.all
    table = self.table_name
    all_arr = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{table}"
    SQL

    self.parse_all(all_arr)
  end

  def self.parse_all(results)
    results.map { |el| self.new(el) }
  end

  def self.find(id)
    table = self.table_name
    table_arr = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{table}"
      WHERE
        id = "#{id}"
    SQL

    self.new(table_arr.first) unless table_arr.first.nil?

  end

  def initialize(params = {})

    params.each do |attr_name, val|
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name.to_sym)
      self.send("#{attr_name}=".to_sym, val)
    end

  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |el| send("#{el}".to_sym) }
  end

  def insert
    col_names = self.class.columns.join(", ")
    question_marks = (["?"] * self.class.columns.length).join(", ")
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_line =  self.class.columns.map { |el| "#{el} = ?"}.join(", ")
    DBConnection.execute(<<-SQL, attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end
end
