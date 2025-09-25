# APS_Linguagem# MinhaLing (APS) — Entrega Parcial 1 (EBNF)

**Data:** 24/Set/2025  
**Escopo desta entrega:** Definição da linguagem em EBNF (Tarefa #1).

## Motivação
Criar uma linguagem de alto nível mínima para controlar uma VM com registradores, memória e sensores. A linguagem facilita lógica de controle (variáveis, condicionais e loops), deixando a geração para Assembly da VM na fase seguinte.

## O que está incluso
- `grammar.ebnf`: gramática em EBNF cobrindo variáveis, expressões, condicionais e loops.
- `examples/`: programas de exemplo que exercitam os principais construtos.

## Próximos passos (próxima entrega)
- Implementar análise léxica (Flex) e sintática (Bison) com base nesta gramática.
- Saída: um programa C/C++ que futuramente emitirá Assembly da VM destino.

## VM alvo (planejado)
Avaliarei **MicrowaveVM** ou **LLVM/JVM**. A escolha final virá na 2ª entrega; a gramática foi desenhada para ser independente da VM.