module Imentore
  class DeliveryMethod::Pac < DeliveryMethod::Base

    def calculate(item ,zip_code, store_zip, amount = 0 , weight = 0)
      frete = Correios::Frete::Calculador.new :cep_origem => store_zip,
                                              :cep_destino => zip_code,
                                              :peso => weight,
                                              :comprimento => 30,
                                              :largura => 15,
                                              :altura => 2
      service = frete.calcular :pac
      @cost = (service.valor + value(amount, weight)).round(2)
      @error = service.erro
      @message = service.msg_erro
      @delivery_time = service.prazo_entrega
      self
    end

    def self.name
      "PAC"
    end

  end
end
