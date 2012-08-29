module Imentore

  # class Tableless < ActiveRecord::Base
  #   def self.columns
  #     @columns ||= [];
  #   end

  #   def self.column(name, sql_type = nil, default = nil, null = true)
  #     columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
  #       sql_type.to_s, null)
  #   end

  #   # Override the save method to prevent exceptions.
  #   def save(validate = true)
  #     validate ? valid? : true
  #   end
  # end

  class Project < ActiveRecord::Base
    has_many :proposes
    # class_inheritable_accessor :columns
    # self.columns = []

    # def self.column(name, sql_type = nil, default = nil, null = true)
    #   columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    # end

    # column :name, :string
    # column :description, :string
    # column :budget, :string
    # column :estimated_of, :string
    # column :duration_of, :string

    # belongs_to :recommendable, :polymorphic => true

    # validates_presence_of :recommendable
    # validates_associated :recommendable
    # validates_format_of :email, :with => /^$|^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
    # validates_presence_of :body
  end

end