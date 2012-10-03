module Imentore
  class DeliveryMethod::SedexACobrar < DeliveryMethod::Base

    def calculate(item ,zip_code, store_zip, amount = 0 , weight = 0)
      frete = Correios::Frete::Calculador.new :cep_origem => store_zip,
                                              :cep_destino => zip_code,
                                              :peso => weight,
                                              :comprimento => 16,
                                              :largura => 15,
                                              :altura => 2,
                                              :valor_declarado => amount

      service = frete.calcular :sedex_a_cobrar
      value = (service.valor + value(amount, weight)).round(2)
      error = service.erro
      error_msg = service.msg_erro
      return value, error, error_msg
    end

    def self.name
      "Sedex a Cobrar"
    end

  end
end
