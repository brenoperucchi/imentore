# encoding: utf-8
require 'active_support/core_ext/big_decimal/conversions'
# require 'active_support/core_ext/float/rounding'
require 'active_support/number_helper'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/output_safety'

def number_with_delimiter(number, options = {})
  options.symbolize_keys!

  begin
    Float(number)
  rescue ArgumentError, TypeError
    if options[:raise]
      raise InvalidNumberError, number
    else
      return number
    end
  end

  defaults = I18n.translate(:'number.format', :locale => options[:locale], :default => {})
  options = options.reverse_merge(defaults)

  parts = number.to_s.to_str.split('.')
  parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")
  parts.join(options[:separator]).html_safe

end

def number_with_price(number, options = {})
  options.symbolize_keys!

  number = begin
    Float(number)
  rescue ArgumentError, TypeError
    if options[:raise]
      raise InvalidNumberError, number
    else
      return number
    end
  end

  defaults           = I18n.translate(:'number.format', :locale => options[:locale], :default => {})
  precision_defaults = I18n.translate(:'number.price.format', :locale => options[:locale], :default => {})
  defaults           = defaults.merge(precision_defaults)

  options = options.reverse_merge(defaults)  # Allow the user to unset default values: Eg.: :significant => false
  precision = options.delete :precision
  significant = options.delete :significant
  strip_insignificant_zeros = options.delete :strip_insignificant_zeros

  if significant and precision > 0
    if number == 0
      digits, rounded_number = 1, 0
    else
      digits = (Math.log10(number.abs) + 1).floor
      rounded_number = (BigDecimal.new(number.to_s) / BigDecimal.new((10 ** (digits - precision)).to_f.to_s)).round.to_f * 10 ** (digits - precision)
      digits = (Math.log10(rounded_number.abs) + 1).floor # After rounding, the number of digits may have changed
    end
    precision -= digits
    precision = precision > 0 ? precision : 0  #don't let it be negative
  else
    rounded_number = BigDecimal.new(number.to_s).round(precision).to_f
  end
  formatted_number = number_with_delimiter("%01.#{precision}f" % rounded_number, options)
  if strip_insignificant_zeros
    escaped_separator = Regexp.escape(options[:separator])
    formatted_number.sub(/(#{escaped_separator})(\d*[1-9])?0+\z/, '\1\2').sub(/#{escaped_separator}\z/, '').html_safe
  else
    formatted_number
  end
end
