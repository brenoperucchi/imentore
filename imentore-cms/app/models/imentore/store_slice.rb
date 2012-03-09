Imentore::Store.class_eval do
  has_many :themes

  def theme
    @theme ||= (themes.first || Imentore::Theme.default.first)
  end
end