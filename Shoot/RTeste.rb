module RTeste
  class Teste
    def self.before(&block)
      yield
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