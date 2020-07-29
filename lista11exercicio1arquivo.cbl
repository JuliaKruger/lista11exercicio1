      $set sourceformat"free"

      *>Divisão de identificação do programa
       Identification Division.
       Program-id. "lista11exercicio1arquivo".
       Author. "Julia Krüger".
       Installation. "PC".
       Date-written. 13/07/2020.
       Date-compiled. 13/07/2020.

      *>Divisão para configuração do ambiente
       Environment Division.
       Configuration Section.
           special-names. decimal-point is comma.

      *>Declaração dos recursos externos
       Input-output Section.
       File-control.
           select arqTemperaturas assign to "arqTemperaturas.txt"
           organization is line sequential
           access mode is sequential
           lock mode is automatic
           file status is ws-fs-arqTemperaturas.

       I-O-Control.


      *>Declaração de variáveis
       Data Division.

      *>----Variáveis de arquivos
       File Section.
       fd arqTemperaturas.
       01 fd-relatorio.
           05 fd-temperatura                       pic s9(03)V99.

      *>----Variáveis de trabalho
       Working-storage Section.

       01 ws-relatorio occurs 30.
           05 ws-temperatura                       pic  s9(03)V99.
       77 ws-soma                                  pic 9(10)V99.

       77 ws-media                                 pic --9,99.
       77 ws-diaacimaabaixo                        pic 9(02).
       77 ws-ind                                   pic 9(2).
       77 ws-fimprograma                           pic x(3).
       77 ws-fs-arqTemperaturas                    pic 9(02).
       77 ws-aux                                   pic x(01).

       01 ws-msn-erro.
           05 ws-msn-erro-ofsset                   pic 9(04).
           05 filler                               pic x(01) value "-".
           05 ws-msn-erro-cod                      pic 9(02).
           05 filler                               pic x(01) value space.
           05 ws-msn-erro-text                     pic x(42).

      *>----Variáveis para comunicação entre programas
       Linkage Section.

      *>----Declaração de tela
       Screen Section.
      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
      *> tela para cadastrar as 30 temperaturas
       01 tela-temperaturas.
           05 blank screen.
           05 line 01 col 01 value "                     ---- Cadastro de Temperaturas ----                        "
           foreground-color 14.
           05 line 03 col 01 value "      Insira 30 temperaturas:                                                  ".
           05 line 04 col 01 value "      Temperatura   :                                                          ".
           05 line 06 col 01 value "                                                                        [ ]Sair".

           05 sc-numero-temp           line 04 col 19 pic 9(02)
           from ws-ind.
           05 sc-temperatura           line 04 col 23 pic 9(02)v99
           using ws-temperatura(ws-ind) foreground-color 14.
           05 sc-sair-programa         line 06 col 74 pic x(01)
           using ws-fimprograma foreground-color 12.

      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
      *> tela para consultar o "número" da temperatura
       01 tela-consulta-temperaturas.
           05 blank screen.
           05 line 01 col 01 value "                     ---- Consulta de Temperaturas ----                        "
           foreground-color 14.
           05 line 03 col 01 value "      Insira uma temperatura (1-30):                                           ".
           05 line 07 col 01 value "                                                                        [ ]Sair".

           05 sc-numero-temp-consulta  line 03 col 38 pic 9(02)
           using ws-diaacimaabaixo.
           05 sc-sair-programa         line 07 col 74 pic x(01)
           using ws-fimprograma foreground-color 12.

      *>                                0    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8
      *>                                5    0    5    0    5    0    5    0    5    0    5    0    5    0    5    0
      *>                            ----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
      *> tela para consultar as informações/dados da temperatura
       01 tela-consulta-temp-dados.
           05 blank screen.
           05 line 01 col 01 value "                     ---- Consulta de Temperaturas ----                        "
           foreground-color 14.
           05 line 03 col 01 value "      Insira uma temperatura (1-30):                                           ".
           05 line 07 col 01 value "                                                                        [ ]Sair".

           05 sc-numero-temp-consulta  line 03 col 38 pic 9(02)
           from ws-diaacimaabaixo.
           05 sc-sair-programa         line 07 col 74 pic x(01)
           using ws-fimprograma foreground-color 12.

      *>Declaração do corpo do programa
       Procedure Division.

           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *> Abrindo o arquivo arqTemperaturas para escrever (output)
      *>------------------------------------------------------------------------
       inicializa section.
           move 0 to ws-soma
           move 1 to ws-ind
           open output arqTemperaturas.
           if  ws-fs-arqTemperaturas <> 0 then
               move 1                                     to ws-msn-erro-ofsset
               move ws-fs-arqTemperaturas                 to ws-msn-erro-cod
               move "Erro ao abrir arq. arqTemperaturas." to ws-msn-erro-text
               perform finaliza-anormal
           end-if
           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *> Processamento do programa
      *>------------------------------------------------------------------------
       processamento section.
      *> perform para variar o ws-ind e cadastrar as 30 temperaturas
           perform until ws-ind > 30
               move 0 to ws-temperatura(ws-ind)
               display tela-temperaturas
               accept tela-temperaturas
      *> movendo as temperaturas para o arquivo
               move ws-temperatura(ws-ind) to fd-temperatura
               add 1 to ws-ind
           end-perform
      *> fechando o arquivo
           close arqTemperaturas.
           if ws-fs-arqTemperaturas <> 0 then
               move 3                                 to ws-msn-erro-ofsset
               move ws-fs-arqTemperaturas                  to ws-msn-erro-cod
               move "Erro ao fechar arq. arqTemperaturas." to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           perform media

           perform ler-temperaturas

      *> aceitando do usuário o "número" da temperatura a ser consultada
           move zeros to ws-diaacimaabaixo
      *> tela para aceitar o "número" da temperatura
           display tela-consulta-temperaturas
           accept tela-consulta-temperaturas
      *> tela para mostrar as informações da temperatura
           display tela-consulta-temp-dados
           evaluate ws-temperatura(ws-diaacimaabaixo)
               when > ws-media
               display "A temperatura desse dia estava acima da media!" at line 04 col 07
               when < ws-media
               display "A temperatura desse dia estava abaixo da media!" at line 04 col 07
           end-evaluate
      *> mostrando as informações na tela
           display "Temperatura do dia " at line 05 col 07
           display ws-diaacimaabaixo at line 05 col 26
           display ": " at line 05 col 28
           display ws-temperatura(ws-diaacimaabaixo) at line 05 col 30
           display "Media: " at line 06 col 07
           display ws-media at line 06 col 14
           accept tela-consulta-temp-dados
           .
       processamento-exit.
           exit.


      *>------------------------------------------------------------------------
      *> Calcular a média das temperaturas
      *>------------------------------------------------------------------------
       media section.
      *> somando todas as temperaturas
           perform varying ws-ind from 1 by 1 until ws-ind > 30
               add ws-temperatura(ws-ind) to ws-soma
           end-perform
      *> descobrindo a média das temperaturas
           divide ws-soma by 30 giving ws-media
           .
       media-exit.
           exit.


      *>------------------------------------------------------------------------
      *> Ler as temperaturas do arquivo
      *>------------------------------------------------------------------------
       ler-temperaturas section.
      *> abrindo o arquivo para ler (input)
           open input arqTemperaturas.
           if  ws-fs-arqTemperaturas <> 0 then
               move 1                                     to ws-msn-erro-ofsset
               move ws-fs-arqTemperaturas                 to ws-msn-erro-cod
               move "Erro ao abrir arq. arqTemperaturas." to ws-msn-erro-text
               perform finaliza-anormal
           end-if

      *> lendo as temperaturas do arquivo
           perform varying ws-ind from 1 by 1 until ws-fs-arqTemperaturas = 10 or ws-ind > 30
               read arqTemperaturas into ws-relatorio(ws-ind)
               if  ws-fs-arqTemperaturas <> 0 and ws-fs-arqTemperaturas <> 10 then
                   move 2                                   to ws-msn-erro-ofsset
                   move ws-fs-arqTemperaturas               to ws-msn-erro-cod
                   move "Erro ao ler arq. arqTemperaturas." to ws-msn-erro-text
                   perform finaliza-anormal
               end-if
      *> movendo as temperaturas do arquivo para a variável da working-storage
               move  fd-temperatura to ws-temperatura(ws-ind)
           end-perform
      *> fechando o arquivo
           close arqTemperaturas.
           if ws-fs-arqTemperaturas <> 0 then
               move 3                                      to ws-msn-erro-ofsset
               move ws-fs-arqTemperaturas                  to ws-msn-erro-cod
               move "Erro ao fechar arq. arqTemperaturas." to ws-msn-erro-text
               perform finaliza-anormal
           end-if
           .
       ler-temperaturas-exit.
           exit.

      *>------------------------------------------------------------------------
      *> Finalização  Anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.
           display erase
           display ws-msn-erro.
           Stop run
           .
       finaliza-anormal-exit.
           exit.

      *>------------------------------------------------------------------------
      *> Finalização Normal
      *>------------------------------------------------------------------------
       finaliza section.
           stop run
           .
       finaliza-exit.
           exit.




