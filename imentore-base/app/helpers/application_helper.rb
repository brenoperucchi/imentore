# encoding: utf-8
module ApplicationHelper
  include ActionView::Helpers

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

  def teste(name)
    "teste"
  end

  def collection_product(variants)
    test = variants.collect do |v_drop|
      Imentore::ProductVariant.find(v_drop.id).options.collect{|option| [option.option_type.name, option.value ]}
      # Imentore::ProductVariant.find(v_drop.id).options.collect{|option| [option.option_type.name, option.option_type.id, option.product_variant_id, option.value ]}
    end
    # binding.pry
  end


end
