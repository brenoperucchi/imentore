module Imentore
  class DeliveryMethod::SedexDez < DeliveryMethod::Base

    def calculate(item ,zip_code, store_zip, amount = 0 , weight = 0)
      frete = Correios::Frete::Calculador.new :cep_origem => store_zip,
                                              :cep_destino => zip_code,
                                              :peso => weight,
                                              :comprimento => 16,
                                              :largura => 15,
                                              :altura => 2
      service = frete.calcular :sedex_10
      value = (service.valor + value(amount, weight)).round(2)
      error = service.erro
      error_msg = service.msg_erro
      return value, error, error_msg
    end

    def self.name
      "Sedex 10"
    end

  end
end
