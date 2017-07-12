require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.camelcase
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name.to_s.downcase}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.singularize.capitalize
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(name) do
      foreign_value = self.send(options.foreign_key)
      class_name = options.model_class
      class_name.where(options.primary_key => foreign_value).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    define_method(name) do
      primary_value = self.send(options.primary_key)
      class_name = options.model_class
      class_name.where(options.foreign_key => primary_value)
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end


  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      through_table = through_options.model_class.table_name
      source_table = source_options.model_class.table_name

      through_results = DBConnection.execute(<<-SQL, self.send(through_options.foreign_key))
        SELECT
        #{source_table}.*
        FROM
        #{through_table}
        JOIN
        #{source_table}
        ON
        #{through_table}.#{source_options.foreign_key} = #{source_table}.#{source_options.primary_key}
        WHERE
        #{through_table}.#{through_options.primary_key} = ?
      SQL
      source_options.model_class.parse_all(through_results).first
    end
  end

end

class SQLObject
  extend Associatable
end
