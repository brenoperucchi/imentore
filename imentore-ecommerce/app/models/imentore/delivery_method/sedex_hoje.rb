module Imentore
  class DeliveryMethod::SedexHoje < DeliveryMethod::Base

    def calculate(item ,zip_code, store_zip, amount = 0 , weight = 0)
      frete = Correios::Frete::Calculador.new :cep_origem => store_zip,
                                              :cep_destino => zip_code,
                                              :peso => weight,
                                              :comprimento => 16,
                                              :largura => 15,
                                              :altura => 2
      service = frete.calcular :sedex_hoje
      (service.valor + value(amount, weight)).round(2)
    end

    def self.name
      "Sedex Hoje"
    end

  end
end
