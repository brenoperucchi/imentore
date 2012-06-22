class CreateFeedback < ActiveRecord::Migration
  def self.up
    create_table :imentore_feedbacks do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :question
      t.text :answer

      t.references :feedbackable, :polymorphic => true
      t.references :user
      t.references :store

      t.timestamps
    end
  end

  def self.down
    drop_table :imentore_feedbacks
  end
end
