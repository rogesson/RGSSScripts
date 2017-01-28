module RTeste
  class Teste
    extend Rmock

    def self.antes(&block)
      yield
    end

    def self.afirmar(valor)
      return true if valor == true
      mensagem_erro_padrao(true, valor)
    end

    def self.nao_afirmar(valor)
      return true if valor == false
      mensagem_erro_padrao(false, valor)
    end

    def self.afirmar_igualdade(isso, aquilo)
      return true if isso == aquilo

      mensagem_erro_padrao(isso, aquilo)
    end

    def self.afirmar_desigualdade(isso, aquilo)
      return true if isso != aquilo

      mensagem_erro_padrao(isso, aquilo)
    end

    def self.isso(nome_do_teste, &block)
      if yield == true
        print '.'
      else
        puts "Erro no teste: #{nome_do_teste}"
        puts yield
      end
    end

    private

    def self.mensagem_erro_padrao(aquilo, isso)
       "    - O valor esperado era: #{aquilo}, mas foi encontrado: #{isso}"
    end
  end
end