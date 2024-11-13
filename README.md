# HaskelChallenge
This was an extremely difficult haskel challenge we had to pull of in an hour. The requirements are in ptbr.

Desenvolva um programa em Haskell que:

1. **Leia termos da lógica de primeira ordem** fornecidos pelo usuário, suportando:

   - **Funções e predicados** com aridade arbitrária.
   - **Variáveis** representadas por letras minúsculas (por exemplo, `x`, `y`, `z`).
   - **Constantes** representadas por letras maiúsculas (por exemplo, `A`, `B`, `C`).
   - **Exemplos de termos válidos:**
     - `f(x, y)`
     - `g(A, h(y, z))`
     - `P(x, F(y), z)`

2. **Implemente um algoritmo de unificação** que:

   - **Tente unificar dois termos** fornecidos pelo usuário.
   - Se a unificação for possível, **retorne o conjunto de substituições mais geral** (MGU - Mínimo Generalizador Unificador).
   - Se não for possível, **informe ao usuário que os termos não são unificáveis**.

3. **Trate erros de sintaxe**, informando ao usuário se os termos fornecidos são inválidos.

**Requisitos:**

- **Analisador Sintático Manual:**
  - Implemente um **parser** manualmente, **sem usar bibliotecas** como `Parsec` ou `Megaparsec`.
  - O parser deve **converter a entrada textual** em uma estrutura de dados que represente os termos.

- **Representação de Termos:**
  - Utilize **tipos de dados algébricos** para representar variáveis, constantes e funções.
  - Exemplo de representação:
    ```haskell
    data Term = Var String | Const String | Fun String [Term]
    ```

- **Algoritmo de Unificação:**
  - Implemente o **algoritmo de unificação de Robinson** para encontrar o MGU.
  - Considere a **verificação de ocorrências** (occurs check) para evitar substituições cíclicas.
  - Utilize uma estrutura adequada para representar as **substituições** (por exemplo, uma lista de pares).

- **Tratamento de Erros:**
  - Utilize monads, como a monad `Either`, para **manejar possíveis erros** durante o parsing e a unificação.

- **Estruturação do Código:**
  - Separe claramente as etapas de **tokenização**, **parsing**, **unificação** e **interação com o usuário**.
  - **Não utilize bibliotecas externas**; todo o código deve ser escrito por você.

**Observações:**

- **Termos na Lógica de Primeira Ordem:**
  - Um **termo** pode ser:
    - Uma **variável** (`x`, `y`, `z`).
    - Uma **constante** (`A`, `B`, `C`).
    - Uma **função** aplicada a uma lista de termos (`f(t1, t2, ..., tn)`).

- **Unificação:**
  - O objetivo é encontrar uma **substituição de variáveis** que torna dois termos **estruturalmente idênticos**.
  - Se tal substituição existir, os termos são **unificáveis**, e a substituição encontrada é o **MGU**.
  - Se não existir, os termos **não são unificáveis**.

**Exemplos:**

- **Exemplo 1:**

  - **Entrada:**
    ```
    Termo 1: f(x, A)
    Termo 2: f(B, y)
    ```
  - **Saída:**
    ```
    Os termos são unificáveis.
    Substituições:
    x ? B
    y ? A
    ```

- **Exemplo 2:**

  - **Entrada:**
    ```
    Termo 1: g(x)
    Termo 2: f(x)
    ```
  - **Saída:**
    ```
    Os termos não são unificáveis (funções diferentes: g e f).
    ```

- **Exemplo 3 (ocurrence check):**

  - **Entrada:**
    ```
    Termo 1: x
    Termo 2: f(x)
    ```
  - **Saída:**
    ```
    Os termos não são unificáveis (falha na verificação de ocorrências).
    ```

**Dicas para Implementação:**

- **Tokenização:**
  - Quebre a entrada do usuário em **tokens** (parênteses, vírgulas, identificadores).
  - Considere o uso de **expressões regulares simples** para identificar tokens.

- **Parsing:**
  - Implemente um **parser recursivo** que constrói a estrutura de termos a partir dos tokens.
  - Trate **erros de sintaxe** e informe ao usuário se a entrada for inválida.

- **Algoritmo de Unificação:**
  - Utilize uma função recursiva que:
    - **Compara** os termos.
    - **Acumula** as substituições necessárias.
    - **Aplica** as substituições aos termos restantes.
  - Certifique-se de **implementar a verificação de ocorrências** para evitar substituições como `x ? f(x)`.

- **Estrutura de Substituições:**
  - Representar substituições como uma lista de pares `(Variable, Term)`.
  - Implemente funções para **aplicar substituições** a termos e **compor substituições**.

- **Monads e Tratamento de Erros:**
  - Utilize a monad `Either` para encapsular possíveis erros durante o processo.
  - Propague erros de forma clara, indicando a **natureza do problema** (sintaxe inválida, falha na unificação, etc.).

- **Interação com o Usuário:**
  - Leia os dois termos a serem unificados.
  - Exiba o resultado da unificação ou a mensagem de erro correspondente.

**Desafio Adicional (Opcional):**

- **Extensão para Predicados:**
  - Estenda o programa para lidar com **predicados** e **literais** (permitindo unificação de fórmulas, não apenas termos).
  - Isso envolveria a representação e unificação de **átomos** como `P(f(x), y)`.

**Objetivo da Tarefa:**

- Esta tarefa visa aprofundar seu entendimento sobre:

  - **Análise sintática** manual e manipulação de estruturas de dados complexas.
  - **Algoritmos fundamentais** na área de inteligência artificial e lógica computacional.
  - **Monads e tratamento de erros** em Haskell.
  - **Estruturação e modularização** de código em um projeto de porte médio.

**Boa sorte e bom trabalho!**
