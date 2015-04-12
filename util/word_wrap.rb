# encoding: UTF-8

=begin 
  * Script RGSS para RPG Maker VX ACE
  
  * Nome: Word Wrap
  * Descrição: Efetua a quebra de linha automáticamente.
  * Autor: Rogesson (Resque)
  * Data: 11/04/2015

  * Exemplo de uso:
  	- tamanho_da_linha = 10
  	- texto_muito_grande = "Um texto muito grande que o limite de letras por linha vai ser de 10 (incluindo espaços)"
	- word_wrap(texto_muito_grande, tamanho_da_linha)
=end

text = "Gerson Camarotti é comentarista político da GloboNews e repórter especial do Jornal das Dez. Pernambucano e torcedor do Náutico desde 1973. Jornalista formado pela Unicap com pós-graduação em ciência política pela UnB, está em Brasília desde 1996, onde passou pelas sucursais das revistas 'Veja' e 'Época', e pelos jornais 'O Globo', 'O Estado de S.Paulo' e 'Correio Braziliense'. Em 2013, foi enviado a Roma pela GloboNews para cobrir o conclave. Fez a primeira entrevista exclusiva do Papa Francisco. É coautor do livro 'Memorial do Escândalo' (2005) e autor de “Segredos do Conclave” (2013)."

def word_wrap(text, line_width)
	words = text.split(" ")
	line = ''
	lines = []
	new_line = true

	for word in words
		if line.size + word.size < line_width
			line << "#{word} "
		else
			new_line = true
			line = "\n#{word} "
		end

		lines << line if new_line
		new_line = false
	end

	lines.join
end