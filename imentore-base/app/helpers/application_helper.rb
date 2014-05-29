# encoding: utf-8
module ApplicationHelper
  include ActionView::Helpers

  def sortable(column, title = nil)
    title ||= column.downcase
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    unless column == sort_column
      link_to I18n.t(title), {:sort => column, :direction => direction}, {:class => ""}
    else
      css_class = if sort_direction == "asc" 
                    "icon-black icon-arrow-down"
                  else
                    "icon-black icon-arrow-up"
                  end
      link_to :sort => column, :direction => direction do
        concat(content_tag(:i, '', :class=>css_class))
        concat(' ' + I18n.t(title))
      end
    end

  end

  def time_zone(params = DateTime.now)
    @object = params
    return DateTime.now if @object.nil?
    @object.in_time_zone(current_store.config.time_zone)
  end

  def button_status(status, url, msg_ok = nil, msg_err = nil)
    msg_ok ||= 'active'
    msg_err ||= 'disable'
    case status
    when 'placed', true
      link_to(url, class: 'btn disabled btn-warning') do
        concat(content_tag(:i, '', :class=>'icon-white icon-ok'))
        concat(' ' + I18n.t(msg_ok))
      end
    when 'pending', false
      link_to(url, class: 'btn disabled btn-danger') do
        concat(content_tag(:i, '', :class=>'icon-white icon-asterisk'))
        concat(' ' + I18n.t(msg_err))
      end
    end
  end 

  def button_product_datatable(product, path, klass, name)
    capture do 
      link_to(path, class: 'btn btn-small') do
        concat(content_tag(:i, '', :class=>klass))
        concat(' ' + I18n.t(name))
      end
    end
  end

  def button_order_status(status)
    case status
    when 'placed', true
      capture do 
        link_to("#", class: 'btn disabled btn-warning') do
          concat(content_tag(:i, '', :class=>'icon-white icon-exclamation-sign'))
          concat(' ' + I18n.t(status))
        end
      end
    # when 'pending', false
    #   link_to("#", class: 'btn disabled btn-danger') do
    #     concat(content_tag(:i, '', :class=>'icon-white icon-remove'))
    #     concat(' ' + I18n.t(status))
    #   end
    # when 'finished', false
    #   link_to("#", class: 'btn disabled btn-success') do
    #     concat(content_tag(:i, '', :class=>'icon-white icon-ok'))
    #     concat(' ' + I18n.t(status))
    #   end
    end
  end

  def types_templates
    ['layout', 'template']
  end

  def states
    # encoding: utf-8
    { "Alagoas" => "AL", "Amapá" => "AP",
      "Amazonas" => "AM",
      "Bahia" => "BA",
      "Ceará" => "CE",
      "Distrito Federal" => "DF",
      "Espírito Santo" => "ES",
      "Goiás" => "GO",
      "Maranhão" => "MA",
      "Mato Grosso" => "MT",
      "Mato Grosso do Sul" => "MS",
      "Minas Gerais" => "MG",
      "Pará" => "PA",
      "Paraíba" => "PB",
      "Paraná" => "PR",
      "Pernambuco" => "PE",
      "Piauí" => "PI",
      "Rio de Janeiro" => "RJ",
      "Rio Grande do Norte" => "RN",
      "Rio Grande do Sul" => "RS",
      "Rondônia" => "RO",
      "Roraima" => "RR",
      "Santa Catarina" => "SC",
      "São Paulo" => "SP",
      "Sergipe" => "SE",
      "Tocantins" => "TO"
    }.sort
  end

  def countries
    {
      "Canada" => "CA",
      "United States" => "US",
      "United Kingdom" => "GB",
      "Argentina" => "AR",
      "Australia" => "AU",
      "Austria" => "AT",
      "Bahamas" => "BS",
      "Belgium" => "BE",
      "Brazil" => "BR",
      "Bulgaria" => "BG",
      "Chile" => "CL",
      "Colombia" => "CO",
      "China" => "CN",
      "Costa Rica" => "CR",
      "Croatia" => "HR",
      "Cyprus" => "CY",
      "Czech Republic" => "CZ",
      "Denmark" => "DK",
      "Ecuador" => "EC",
      "Estonia" => "EE",
      "Finland" => "FI",
      "France" => "FR",
      "Germany" => "DE",
      "Greece" => "GR",
      "Guadeloupe" => "GP",
      "Hong Kong" => "HK",
      "Hungary" => "HU",
      "Iceland" => "IS",
      "India" => "IN",
      "Indonesia" => "ID",
      "Ireland" => "IE",
      "Israel" => "IL",
      "Italy" => "IT",
      "Jamaica" => "JM",
      "Japan" => "JP",
      "Kazakhstan" => "KZ",
      "Latvia" => "LV",
      "Lithuania" => "LT",
      "Luxembourg" => "LU",
      "Malaysia" => "MY",
      "Malta" => "MT",
      "Mexico" => "MX",
      "Netherlands" => "NL",
      "New Zealand" => "NZ",
      "Norway" => "NO",
      "Peru" => "PE",
      "Philippines" => "PH",
      "Poland" => "PL",
      "Portugal" => "PT",
      "Romania" => "RO",
      "Russia" => "RU",
      "Singapore" => "SG",
      "Slovakia" => "SK",
      "Slovenia" => "SI",
      "South Africa" => "ZA",
      "South Korea" => "KR",
      "Spain" => "ES",
      "St. Vincent" => "VC",
      "Sweden" => "SE",
      "Switzerland" => "CH",
      "Syria" => "SY",
      "Taiwan" => "TW",
      "Thailand" => "TH",
      "Tanzania, United Republic Of" => "TZ",
      "Trinidad and Tobago" => "TT",
      "Turkey" => "TR",
      "United Arab Emirates" => "AE",
      "Uruguay" => "UY",
      "Venezuela" => "VE"
    }.sort
  end

  def breadcrumb(array)
    output = '
    <ul class="breadcrumb">'
    size = array.size - 1
    array.each {
      |e| e.each {
        |key, value|
        if value.empty?
          output += key
        else
          output << content_tag(:li)
          output += link_to(key, value)
        end
        output += " > " if size > 0
      }
      size -= 1
    }
    output += '</ul>
    '
    return output
  end

  def url(params)
    case params
    when 'login'
      "/users/login"
    end
  end

  def collection_product(variants)
    ret = variants.collect do |variant_drop|
      Imentore::ProductVariant.find(variant_drop.id).options.collect{|option| [option.option_type.name, option.value ]}
    end
  end

  def breaking_wrap_wrap(txt, col = 80)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/,
      "\\1\\3\n")
  end


end