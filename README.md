# ♠Blackjack em Assembly (RISC-V) ♦

Este projeto é uma implementação do clássico jogo de cartas Blackjack (também conhecido como 21), desenvolvido puramente em linguagem de montagem para a arquitetura RISC-V. O jogo é executado em um ambiente de terminal e simula uma partida entre um jogador e o "dealer" (a casa).

O código foi desenvolvido como parte de estudos em organização de computadores, com foco na manipulação de memória, controle de fluxo e chamadas de sistema em baixo nível.

## Funcionalidades

* **Lógica Completa de Jogo**: O programa gerencia o baralho, distribui as cartas iniciais e controla os turnos do jogador e do dealer.
* **Interface Interativa**: O jogador interage via terminal para tomar decisões, como "hit" (pedir mais uma carta) ou "stand" (manter a mão atual).
* **Contagem de Pontos**: Calcula a pontuação das mãos, tratando o **Ás** de forma especial (valendo 11 ou 1, para evitar estourar 21 pontos).
* **Regras do Dealer**: O dealer segue a regra padrão de pedir cartas até atingir 17 pontos ou mais.
* **Sistema de Baralho**: Gerencia um baralho de 52 cartas, controlando as cartas já utilizadas e embaralhando quando necessário (se o número de cartas for baixo).
* **Placar de Vitórias**: Mantém um registro das vitórias do jogador e do dealer durante a sessão de jogo.
* **Jogar Novamente**: Ao final de cada rodada, o jogador tem a opção de iniciar uma nova partida.

## Como Funciona

O código é estruturado em várias seções e funções para organizar a lógica do jogo:

1.  **`.data`**: Define todas as mensagens de texto que serão exibidas ao usuário, bem como as variáveis globais para armazenar o estado do jogo (cartas do baralho, mão do jogador, mão do dealer, pontuações e placar).
2.  **`main`**: É o ponto de entrada do programa. Inicializa o jogo e controla o fluxo principal, chamando as funções para cada etapa (distribuição, turno do jogador, turno do dealer, etc.).
3.  **Funções de Jogo**:
    * `adicionaCartaJogador` / `adicionaCartaDealer`: Lidam com a lógica de "pescar" uma carta aleatória do baralho e adicioná-la à mão correspondente.
    * `controleCartas` / `randnum`: Gerenciam o baralho, garantindo que apenas cartas disponíveis sejam sorteadas.
    * `comparacao`: Compara a pontuação final do jogador e do dealer para determinar o vencedor.
    * `estouroJog` / `estouroDea`: Tratam os casos em que a pontuação ultrapassa 21.
4.  **Funções de Interface (`print`)**: Um conjunto de funções responsáveis por imprimir mensagens e o estado atual do jogo no terminal.

## ⚙️ Como Executar

Para executar este código, você precisará de um simulador de ambiente RISC-V, como o **RARS (RISC-V Assembler and Runtime Simulator)**.

1.  Baixe e instale o [RARS](https://github.com/TheThirdOne/rars/releases).
2.  Abra o arquivo `blackjack.asm` no simulador.
3.  Vá para a aba **"Execute"**.
4.  Clique em **"Assemble"** (ou F3) para compilar o código.
5.  Clique em **"Go"** (ou F5) para iniciar a execução do jogo.
6.  A interação com o jogo ocorrerá no console da aba **"Run I/O"**.
