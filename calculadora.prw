/*+=================================+
|Programa: Rotina que ir� centralizar todas as informa��es pertinentes ao Recrutamento e Sele��o de Pessoas amarrando assim com o Budget
|Autor: Elker G.B.
|Data cria��o: 20/01/2025
|###
|Vers�o     |Data           |Funcionalidades
|0.0.0      |20/01/2025     | Desenvolvimento inicial contemplando v�nculo com BGT(tabela ZZO classe QDPESS)
|           |               |   campos anonimizados, como nome, telefone, CPF
|           |               |   demais campos seriam Previs�o Admiss�o, CC, Fun��o, Obeserva��es, Status
|           |               |   vinculo futuro com Compet�ncia e GHE
|1.0.0      |               | Colocado em opera��o com:
|           |26/02/2025     |   atendimento as Abas Ata/Solcita��o
+=================================+*/
 
#include 'totvs.ch'
#include "fileio.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "rwmake.ch"
#include 'Protheus.ch'
#include 'FWMBROWSE.CH'

//Designer da Calculadora

User Function pedroneto()
    
    Local oDlg := MSDialog():New(0,0,450,320,'Calculadora',,,,,,,,,.T.)

    Private cOperat := ""
    Private cValor1 := ""
    Private cValor2 := ""
    Private cRest := ""
    Private nRest := 0

    TGet():New( 037,03,{||cRest},oDlg,158,10,,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,,,,, )
    TGet():New( 052,03,{||nRest},oDlg,158,12,,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,,,,, )

    TButton():New( 070, 003, "%",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 070, 043, "CE",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 070, 083, "C",oDlg,{||Clear()}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 070, 123, "<-",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 096, 003, "1/x",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 096, 043, "x�",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 096, 083, "�Vx",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 096, 123, "/",oDlg,{||cOp_Sinal("/")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 122, 003, "7",oDlg,{||cOp_Num("7")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 122, 043, "8",oDlg,{||cOp_Num("8")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 122, 083, "9",oDlg,{||cOp_Num("9")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 122, 123, "*",oDlg,{||cOp_Sinal("*")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 148, 003, "4",oDlg,{||cOp_Num("4")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 148, 043, "5",oDlg,{||cOp_Num("5")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 148, 083, "6",oDlg,{||cOp_Num("6")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 148, 123, "-",oDlg,{||cOp_Sinal("-")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 174, 003, "1",oDlg,{||cOp_Num("1")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 174, 043, "2",oDlg,{||cOp_Num("2")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 174, 083, "3",oDlg,{||cOp_Num("3")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 174, 123, "+",oDlg,{||cOp_Sinal("+")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    
    TButton():New( 200, 003, "+/-",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 200, 043, "0",oDlg,{||cOp_Num("0")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 200, 083, ",",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 200, 123, "=",oDlg,{||cCalculo()}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    oDlg:Activate(,,,.T.,,,EnchoiceBar(oDlg,{||oDlg:End()} ,{|| oDlg:End() }))


Return

//C�lculo Matem�tico

Static Function cOp_Sinal(cSinal)

    If cValor2 <> ""
        cCalculo()
    EndIf
    cOperat := cSinal
    cRest := cOperat
   
Return

Static Function cOp_Num(cNum)

    If cOperat <> ""
        cValor1 += cNum
        cRest := cValor1
    Else
        cValor2 += cNum
        cRest := cValor2
    EndIf

Return

Static Function cCalculo()

    If cValor2 <> ""
        If cOperat == "+"
            nRest := VAL(cValor1) + VAL(cValor2)
        ElseIf cOperat == "-"
            nRest := VAL(cValor1) - VAL(cValor2)
        ElseIf cOperat == "*"
            nRest := VAL(cValor1) - VAL(cValor2)
        ElseIf cOperat == "/"
            nRest := VAL(cValor1) - VAL(cValor2)
        EndIf
        //cValor1 := CVALTOCHAR(nRest)
        //cValor2 := ""
    EndIf

Return

Static Function Clear()

    cValor1 := ""
    cValor2 := ""
    cOperat := ""
    cRest := ""
    nRest := 0

Return
