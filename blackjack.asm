# estudantes Maiqueli(20230004643)

.data
msgInicial:     .asciz "\n\nbem-vindo ao blackjack, let's go gambling! \n\n"
msgTotalCartas: .asciz "\ntotal de cartas: "
msgPont:        .asciz "\npontuacao"
msgDealer:      .asciz "\n	dealer: "
msgJogador:     .asciz "\n	jogador: "
msgIniciar:	.asciz "\n\nexcelentissimo professor caimi, deseja jogar? (1 - sim, 2 - nao): "
msgWinJog:	.asciz "\n\nvocê venceu! Iupi!\n"
msgWinDea:	.asciz "\n\ndealer venceu! Desista dos seus sonhos!\n"
msgEmpate:	.asciz "\n\nempate!\n"
msgRecebeJog:	.asciz "\n\no jogador recebe: "
msgE:		.asciz " e "
msgRevelaDea1:	.asciz "\n\no Dealer revela: "
msgRevelaDea2:	.asciz "uma carta oculta \n"
msgMao:		.asciz "\n\nsua mao: "
msgMaoDea:	.asciz "\n\no dealer revela sua mao: "
msgSimboloM:	.asciz " + "
msgSimboloI:	.asciz " = "
msgAcao:	.asciz "\n\n\no que voce deseja fazer? (1 - hit, 2 - stand): "
msgHitDea:	.asciz "\n\no dealer deve continuar pedindo cartas...\n"
msgRecebeDea:	.asciz "\no dealer recebe: "
msgEstouroDea:	.asciz "\no dealer estourou! "
msgProvissoria:	.asciz "\n\n\nFim!\nObrigada por jogar!\nThank you for playing!\nXièxiè n? wán yóuxì\nSpasibo za igru!\n¡Gracias por jugar!\Shukran lil-la'ib\n\n"
msgJogarNov: 	.asciz "\n\n\nexcelentissimo professor caimi, deseja jogar novamente? (1 - sim, 2 - nao): "

cartas:         .word 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4  # lembrar q cada word ocupa 4bytes
totalCartas:    .word 52  # meu contador inicial de cartas baralho todo
jogadorCartas:  .space 40  
dealerCartas:   .space 40  
jogadorNumCartas: .word 0  # qtd cartas mao jogador
dealerNumCartas:  .word 0  # qtd cartas mao dealer
jogadorPontuacao: .word 0  
dealerPontuacao:  .word 0  
jogadorVitorias: .word 0  
dealerVitorias: .word 0

.text

main:	# muito la e li achei too much poluido e fiz tudo funcao mia amiga agora so nas call quase me matei porque fiquei chamando funcao dentro de funcao e tinha esquecido de salvar o ra da funcao original ai quebrei a cabess ate descobri o erro bobo
	
	# NAO OTIMIZEI O USO DOS MEUS RGEISTRADORES TEMPORÁRIO (i love t0-t6) E SO FUI USANDO DENTRO DAS FUNÇÕES (esbanjei) DEPOIS MELHORO OK AI TIVE QUE USAR ESSES tipo S Q N EH O IDEAL NER
	addi sp, sp, -16
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	
	la s0, jogadorVitorias
	la s1, dealerVitorias
	la s2, jogadorPontuacao
	la s3, dealerPontuacao
	
	sw zero, 0(s0) # jogadorVitorias
	sw zero, 0(s1) # dealerVitorias ai prof sei q aqui ta erroneo meu uso mas eh porque acabou meus temporarios e depoiis vou ajustar o uso deles (otimizar) e ai paro de usar esses daqui pra isso
	sw zero, 0(s2) # jogadorPontuacao
	sw zero, 0(s3) # dealerPontuacao
	
	call printMsgInicial 
	call printMsgTotalCartas
	call printPontuacao
	call printMsgIniciar

	li a7, 5  # le a entrada de inteiro 1 ou 2 de sim ou nao, armazena no a0
	ecall
	li t0, 1  # 1 que significa sim vai para t0
	bne a0, t0, fim  # compara a resposta com 1, se a0 != 1 pula para fim, nao fiz outras validacoes pq preguiss
	
distribuicao:
	call printMsgTotalCartas
	call printPontuacao
	call adicionaCartaJogador
	call adicionaCartaJogador
	call printMsgRecebeJogador
	
	call adicionaCartaDealer
	call adicionaCartaDealer
	call printMsgDeaRevela
	
	call printMsgMaoJogador

turnoJogLoop:	# ainda n fiz o sistema especial de pontos das cartas, entao as cartas ainda valem seus indices
	call printMsgAcao
	li a7, 5  # le a entrada de inteiro 1 ou 2 de hit ou stay, armazena no a0
	ecall
	li t0, 1  # 1 que significa sim vai para t0
	bne a0, t0, turnoDeaLoop  # compara a resposta com 1, se a0 != 1 pula para o turno do dealer
	call adicionaCartaJogador
	call printMsgRecebeJ
	call controleMaoJog
	li t1, 21		# bota em t1 o limite de 21 para comparação
	bgt s2, t1, estouroJog	# vai de estouros e perde imediatamente
	j turnoJogLoop

turnoDeaLoop:	# lembrar: hit se pont do dea > ou = 17
	call controleMaoDea
	lw s3, dealerPontuacao		# carrega em s3 a pont do dealer
	li t0, 17		# bota 17 em t0 para usar na comparação
	bge s3, t0, comparacao		# se a pont for >= 17 o dealer stay e vai para a fase de comparacao. Se não segue:
	la a0, msgHitDea	# mensagi dealer hit
	call printString
	call adicionaCartaDealer	# pesca nova carta pro dea e atualiza o s3 com a pont do dea
	la a0, msgRecebeDea
	call printString
	mv a0, t0		# boto a nova card em t0
	call printInt
	li t1, 21		# carrega em t1 o limite para comparacao
	bgt s3, t1, estouroDea		# se pont do dea eh maior q 21 vai pro estouro dele
	j turnoDeaLoop
	

printInt:	# bem generico para printa sos zilhoes de numeros nas dez mil rodadas
	li a7, 1	# printa um inteiro
   	ecall
	ret

printString:	# vou chamar dentro dos print de mensagem e n quero ficar repetindo
	li a7, 4	# printa mensagem personalizada
	ecall
	ret
	
printMsgInicial:	# escrevendo porque ja to sofrendo de anteciáçãp por ficar digitando isso daqui pqp
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgInicial
	call printString
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
printMsgTotalCartas:
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgTotalCartas
	call printString
	la t0, totalCartas
	lw a0, 0(t0)
	call printInt
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

printPontuacao:		# usei os registrador s aqui ner, mas depois uso outros rsrsrsrsr
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgPont
	call printString
	la a0, msgJogador
	call printString
	
	la t0, jogadorVitorias
	lw a0, 0(t0)
	call printInt
	la a0, msgDealer
	call printString
	la t0, dealerVitorias
	lw a0, 0(t0)
	call printInt
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

printMsgIniciar:
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgIniciar
	call printString
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
printMsgRecebeJogador:
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgRecebeJog
	call printString
	la t0, jogadorCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw a0, 0(t0)	# primeira carta do vetor	
	call printInt
	la a0, msgE	# irmao pra imprimir um E sabe
	call printString
	lw a0, 4(t0)		# segunda carta do vetor
	call printInt
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
printMsgRecebeJ:	# basicamnete tudo copia e cola todos os print cansei
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgRecebeJog
	call printString
	mv a0, t0
	call printInt
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

printMsgAcao:	# basicamnete tudo copia e cola todos os print cansei
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgAcao
	call printString
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
    
printMsgMaoJogador:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMao
	call printString
	la t0, jogadorCartas        # ponteiro para ender inícial do vetor das cartas do jog
	li t1, 2                    # contador para percorrer o vetor, comeco em 2 porque ja vou printar as 2 primeira fora do loop
	lw t2, jogadorNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	
printSomaJ:
	la a0, msgSimboloI
	call printString
	mv a0, s2 # eh pra estar em s2
	call printInt
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
printMsgMaoJogador2:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMao
	call printString
	la t0, jogadorCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw t2, jogadorNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 8(t0)	# printo a terceira carta
	call printInt
	j printSomaJ

printMsgMaoJogador3:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMao
	call printString
	la t0, jogadorCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw t2, jogadorNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 8(t0)	# printo a terceira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 12(t0)	# printo a quarta carta
	call printInt
	j printSomaJ
	
printMsgMaoJogador4:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMao
	call printString
	la t0, jogadorCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw t2, jogadorNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 8(t0)	# printo a terceira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 12(t0)	# printo a quarta carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 16(t0)	# printo a quinta carta
	call printInt
	j printSomaJ

printMsgMaoJogador5:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMao
	call printString
	la t0, jogadorCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw t2, jogadorNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 8(t0)	# printo a terceira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 12(t0)	# printo a quarta carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 16(t0)	# printo a quinta carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 20(t0)	# printo a sexta carta
	call printInt
	j printSomaJ

printMsgMaoDea:
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgRevelaDea1
	call printString
	la a0, msgMao
	call printString
	la t0, dealerCartas        # ponteiro para ender inícial do vetor das cartas do dea
	lw t2, dealerNumCartas     # qts de cartas do dealer
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	
printSomaD:
	la a0, msgSimboloI
	call printString
	mv a0, s3 # eh pra estar em s2
	call printInt
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
	
printMsgMaoDea1:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMaoDea
	call printString
	la t0, dealerCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw t2, dealerNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	j printSomaD
	
printMsgMaoDea2:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMaoDea
	call printString
	la t0, dealerCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw t2, dealerNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 8(t0)	# printo a terceira carta
	call printInt
	j printSomaD

printMsgMaoDea3:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMaoDea
	call printString
	la t0, dealerCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw t2, dealerNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 8(t0)	# printo a terceira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 12(t0)	# printo a quarta carta
	call printInt
	j printSomaD
	
printMsgMaoDea4:
	addi sp, sp, -4
	sw ra, 0(sp) 
	la a0, msgMaoDea
	call printString
	la t0, dealerCartas        # ponteiro para ender inícial do vetor das cartas do jog
	lw t2, dealerNumCartas     # qts de cartas do jogador
	
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 4(t0)	# printo a segunda carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 8(t0)	# printo a terceira carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 12(t0)	# printo a quarta carta
	call printInt
	la a0, msgSimboloM	# printo o +
	call printString 
	lw a0, 12(t0)	# printo a quinta carta
	call printInt
	j printSomaD

	
printMsgDeaRevela:
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgRevelaDea1
	call printString
	la t0, dealerCartas        # ponteiro para ender inícial do vetor das cartas do dea
	lw a0, 0(t0)	# printo a primeira carta
	call printInt
	la a0, msgE	# irmao pra imprimir um E sabe
	call printString
	la a0, msgRevelaDea2
	call printString
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

printMsgProv:	# fiz porque sou boba, apenas para a entrega parcial
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, msgProvissoria
	call printString
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

randnum:  # adaptei do codigo dos exercicio porque sou preguicosa, vou anotar o funcionamento abaixo pra vc entender mia amiga
	addi sp, sp, -4  # pegamos um espaco na pilha
	sw ra, 0(sp)  # salva endereco de retorno
	li a0, 13  # boto o 13 no a0 (carta max k = 13)
	mv a1, a0  # passa o valor do a0 para a1, entao a1 = 13
	li a7, 42  # syscall 42 q gera num aleatorio entre 0 e a1 - 1, fica assim o range [0, a1 - 1] entao temos 0 ate 12, vamos precisar somar 1 no final para ficar num intervalo de 1 a 13
	ecall  # aqui o a0 vai receber um valor entre 0 e 12 pro causa de [0, a1 - 1], lembrando que no nosso a1 tem o 13 (esse syscall usa os reg a1 e a0, tem sobre ele no botao [?] acima)
	addi a0, a0, 1  # aqui ajustamos para o a0 (saida final) receber 1 para ficar com o valor entre 1 e 13
	lw ra, 0(sp)  # voltamos endereco de retorno salvo
	addi sp, sp, 4  # free espaco da pilha q usamos
	ret  # retornamos com o resultado do valor em a0 no range (1, 13)

controleCartas:
	addi sp, sp, -4    # criamos espaço na pilha
	sw ra, 0(sp)       # salva ender de retorno ner importante
	
controleCartasLoop:	# vo ficar voltando caso a carta n esteja disponivel
	call randnum  # chama la a funcao q gera carta entre 1 e 13 com resultado em a0
	mv t0, a0	# movo o valor de a0 para t0 para usar na outra funcao de carta antes d emodificar
	addi t1, a0, -1  # aqui o t1 vai receber o indice da carta que vem do a0 e subtrair 1 para ficar igual o indice do vetor (0 a 12)
	la t2, cartas  # botamos em t2 o endereco do nosso vetor de cartas (4,...,4)
	slli t1, t1, 2  # t1 vai receber o valor de t1 deslocado 2 <<, que eh o mesmo que multiplicar por 4, que eh quantos bytes o word usa
	add t3, t2, t1  # o t3 vai receber o endereco da carta q eh o endereco inicial do vetor + o deslocamento do indice da carta pescada
	lw t4, 0(t3)  # salvamos em t4 o valor que esta no endereco de t3, que eh quantas cartas daquele indice ainda restam
	beq t4, zero, controleCartasLoop  # checamos se ainda ha cartas disponiveis (t4!=0), se n chamamos novamente funcao para pescar outra carta
	addi t4, t4, -1  # controle para reduzir a carta tirada do seu indice no vetor
	sw t4, 0(t3)  # salvamos a nova qtd da carta (t4) no endereco dela em t3
	la t5, totalCartas  # ia fazer uma funcao apenas para isso mas fiquei com preguica e vou fazer aqui junto, ai smepre q pesca reduz 1 do baralho
	lw t6, 0(t5)  # acima eu botei o endereco da variavel em t5 e aqui vou colocar a qtd de cartas em t6
	addi t6, t6, -1  # reduzo a carta pescada da qtd de cartas disponiveis para pesca
	sw t6, 0(t5)  # salvo a nova qts de cartas em t5
	mv a0, t0	# vo mover carta sorteada de volta para a0 antes de retornar so por preocaução
	lw ra, 0(sp)	# restaura o ender de retorno
	addi sp, sp, 4	# free os espaços d apilha
	ret

adicionaCartaJogador: # um monte de ponteiro e contador pra add carta no vetor e aumenta qtd de carta na mao
	addi sp, sp, -4		# abra-te espaço reservado
	sw ra, 0(sp)		# salva ender de ret
	call controleCartas	# se n me engano retorna o valor da carta em a0
	mv t0, a0	# viciada em mover
	la t1, jogadorNumCartas  # pega o ender do numero atual de cartas do jogador e bota em t1
	lw t2, 0(t1)  # acessamos o num atual de cartas do jogador e salva em t2
	la t3, jogadorCartas  # t3 aponta o endereco base do vetor q guarda as cartas do jogador
	slli t4, t2, 2  # desloca para achar o espaço livre no memso esquema de << 2, salva em t4
	add t5, t3, t4  # salvamos em t5 a soma do end com t4 que aponta pro prox espaço livre
	sw t0, 0(t5)  # guarda o valor carta que ta no s0 na posicao calculada q foi movido do a0 (1-13)
	addi t2, t2, 1  # aumenta o contador de cartas do jogador
	sw t2, 0(t1)	# atualiza a qtd de carta
	la t6, jogadorPontuacao	# carrega end da pontuacao do jog em t6
	lw s2, 0(t6)	# carrego a pontuacao atual em s2
	li t3, 1
	beq t0, t3, ehAsJ           # se for 1 eh as
	li t3, 10
	bge t0, t3, ehFigJ 	# maior que 10
	add s2, s2, t0	# atualizo a pontuacao com a nova carta q vale seu numero, t0 ainda tem o valor ner
	
fimCalculoJ:

	sw s2, 0(t6)	# salvo a pontucao no endereco da variavel pontucao jog ner (s2)
	lw ra, 0(sp)	# carrega o endereco pra nos voltar
	addi sp, sp, 4	# restaura pilha
	ret
ehFigJ:
	addi s2, s2, 10
	j fimCalculoJ
ehAsJ:
	addi s2, s2, 11
	li t1, 21
	ble s2, t1, fimCalculoJ
	addi s2, s2, -10 
	j fimCalculoJ

adicionaCartaDealer: # igual o sistema do jogador, apenas muda o armazenamento em s3
	addi sp, sp, -4		
	sw ra, 0(sp)		
	call controleCartas	
	mv t0, a0	
	la t1, dealerNumCartas 
	lw t2, 0(t1)  
	la t3, dealerCartas  
	slli t4, t2, 2  
	add t5, t3, t4 
	sw t0, 0(t5) 
	addi t2, t2, 1  
	sw t2, 0(t1)	
	la t6, dealerPontuacao	
	lw s3, 0(t6)	
	li t3, 1
	beq t0, t3, ehAsD          
	li t3, 10
	bge t0, t3, ehFigD 	
	add s3, s3, t0	
	
fimCalculoD:

	sw s3, 0(t6)	# salvo a pontucao no endereco da variavel pontucao dealer ner (s3)
	lw ra, 0(sp)	# carrega o endereco pra nos voltar
	addi sp, sp, 4	# restaura pilha
	ret
ehFigD:
	addi s3, s3, 10
	j fimCalculoD
ehAsD:
	addi s3, s3, 11
	li t1, 21
	ble s3, t1, fimCalculoD
	addi s3, s3, -10 
	j fimCalculoD

estouroJog:
	la a0, msgWinDea	# mensagem de win do dealer
	call printString
	la t0, dealerVitorias		# bota o endereço da variavel em t0
	lw t1, 0(t0)		# t1 agora tem o num de win do dealer do endereço
	addi t1, t1, 1		# incrementa numero vitoria do dealer
	sw t1, 0(t0)		# armazena o num de win atualizado no endereço da variavel
	j endRound

endRound:
	call printPontuacao	# exibe o placar de ambos
	la a0, msgJogarNov
	call printString
	li a7, 5		# ler resposta do prof em a0
	ecall
	li t0, 1		# o de sempre armazena 1 em t0 para comparação
	bne a0, t0, fim		# compara a resposta e se for diferente de 1 vai pro fim do prog, se n segue:
	la t0, jogadorNumCartas		# t0 carrega endereço da variavel ai
	sw zero, 0(t0)		# zera n cartas do jog
	la t0, dealerNumCartas		# pipipi carrega endereço
	sw zero, 0(t0)		# zera n cartas do dealer
	la t0, jogadorPontuacao		# carrega ender da pont do jogo
	sw zero, 0(t0)		# zera pont do jog
	la t0, dealerPontuacao		# carrega ender da pont do dealer
	sw zero, 0(t0)		# zera pont do delear amem acabou
	lw t0, totalCartas	
	li t1, 12
	bge t0, t1, distribuicao	# verifica se eh necessário restaurar baralho, se n, vai para distribuicao
	
resetBaralho:
	addi sp, sp, -4
	sw ra, 0(sp)
	li t0, 52
	la t1, totalCartas
	sw t0, 0(t1)
	la t0, cartas
	li t1, 13	# meu tam do vetor
	li t2, 0	# contador do loop
	li t3, 4           # n carta de cada nipe

resetLoop:
	beq t2, t1, fimReset	# contador igual a 13 saí do loop
	slli t4, t2, 2     # deslocar em t4 = i * 4
	add t5, t0, t4     # enderda posição atual
	sw t3, 0(t5)       # salvamos o valor 4 na posicao
	addi t2, t2, 1     # incrmeneta o contador
	j resetLoop       

fimReset:
	lw ra, 0(sp)
	addi sp, sp, 4
	j distribuicao		# pula para distribuição inicial de carta

estouroDea:
	la a0, msgEstouroDea
	call printString
	la a0, msgWinJog
	call printString
	la t0, jogadorVitorias	# carrega endereco da variavel em t0
	lw t1, 0(t0)	# carrega em t1 o num das vitorias do jog
	addi t1, t1, 1	# soma essa vit
	sw t1, 0(t0)	# ai armazena o num atualizado no ender da variavel
	j endRound
	
comparacao:
	lw s2, jogadorPontuacao		# carrega pont do jog em S2
	lw s3, dealerPontuacao		# carrega pont do dea em S3
	bgt s2, s3, vitoriaJog	# jog s2 > dea s3
	bgt s3, s2, vitoriaDea	# jog s2 < dea s3
	la a0, msgEmpate	# se n for nenhum eh empate ai imprime mensagem de empate e n atualiza o quadro geral de vit
	call printString
	j endRound

vitoriaJog:
	la a0, msgWinJog
	call printString
	la t0, jogadorVitorias	# carrega endereco da variavel em t0
	lw t1, 0(t0)	# carrega em t1 o num das vitorias do jog
	addi t1, t1, 1	# soma essa vit
	sw t1, 0(t0)		# armazena novo valor no ender da vari
	j endRound

vitoriaDea:
	la a0, msgWinDea	# ctrl c ctrl v da vit do jog adapatado para o dea
	call printString
	la t0, dealerVitorias	
	lw t1, 0(t0)		
	addi t1, t1, 1		
	sw t1, 0(t0)		
	j endRound
	
controleMaoJog:
	lw t2, jogadorNumCartas     # qts de cartas do jogador
	li t4, 3
	beq t2, t4, printMsgMaoJogador2
	li t4, 4
	beq t2, t4, printMsgMaoJogador3
	li t4, 5
	beq t2, t4, printMsgMaoJogador4
	li t4, 6
	beq t2, t4, printMsgMaoJogador5
	ret

controleMaoDea:
	lw t2, dealerNumCartas     # qts de cartas do jogador
	li t4, 2
	beq t2, t4, printMsgMaoDea1
	li t4, 3
	beq t2, t4, printMsgMaoDea2
	li t4, 4
	beq t2, t4, printMsgMaoDea3
	li t4, 5
	beq t2, t4, printMsgMaoDea3
	ret
    
fim:
	call printMsgProv
	li a7, 10  # 10 eh o cod padrao para encerrar essa bomba de programa
	ecall

