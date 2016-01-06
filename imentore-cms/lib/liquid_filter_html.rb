module LiquidFilterHtml
  include ActionView::Context
  # include ActionView::Helpers::URLHelper
  # include ActionDispatch::Routing::Mapper
  # include ActionView::Helpers
  include ActionView::Helpers::FormTagHelper 
  include Imentore::Core::Engine.routes.url_helpers
  include ActionDispatch::Routing::Mapper::Base

  def birthdate_select(klass_name)
    params = @context.registers[:controller].env["rack.request.form_hash"]
    @default_option = { :default => {},
                        :start_year => 1900, :end_year => Date.today.year - 8,
                        :order => [ :day, :month, :year], use_month_numbers: true
                      } 
    if params
      params = params["customer"]
      {day: "birthdate(3i)" , month: "birthdate(2i)", year: "birthdate(1i)"}.each do |key, value|
        unless params[value].blank?
          @default_option[:default].merge!(key.to_sym => params[value])
        end
      end
    end
    date_select(klass_name, "birthdate", @default_option)
  end

  def option_select(selected, value, name)
    if selected != value
      "<option label='#{name}' id='#{name}' value='#{value}')/>"
    else
      "<option label='#{name}' id='#{name}' value='#{value}' selected='selected')/>"
    end
  end

  def select_selected(param, value)
    {'selected' => 'selected'} if param == value
  end

  def url_param(args)
    @params = @context.registers[:controller].params
    if @params["_method"]
      args = args.scan(/[A-Za-z0-9_]+/)
      args.each{|x| @params = @params[x.strip]}
      @params
    end
  end

  def param_value(param, value)
    @context.registers[:controller].params[param] == value
  end

  def param_active(param, value, default = nil)
    if @context.registers[:controller].params[param.to_sym] == value 
      "active" 
    elsif 
      @context.registers[:controller].params[param.to_sym].blank? and value == default
      "active" 
    end
  end
end