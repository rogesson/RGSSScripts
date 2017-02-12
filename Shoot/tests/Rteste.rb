# Autor: Resque
# E-mail: Rogessonb@gmail.com
# Data: 28/01/2017
# Engine: RPG Maker Ace VX

module RTeste
  class Teste
    extend Rmock

    @@sujeito = nil

    def self.sujeito
      @@sujeito = yield if block_given?
      @@sujeito
    end

    def self.antes(&block)
      yield
    end

    def self.descrever(method_name)
      puts "executando #{method_name}\n\n"
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

    @@sujeito = nil
  end
end