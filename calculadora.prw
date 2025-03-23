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
    Private cRest := "0"
    Private nOprF := 0
    Private cVlr := ""

    TGet():New( 037,03,{||cRest},oDlg,158,10,,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,,,,, )
    TGet():New( 052,03,{||nOprF},oDlg,158,12,,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,,,,, )

    TButton():New( 070, 003, "%",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 070, 043, "CE",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 070, 083, "C",oDlg,{||oPM("C")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 070, 123, "<-",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 096, 003, "1/x",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 096, 043, "x�",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 096, 083, "�Vx",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 096, 123, "/",oDlg,{||oPM("/")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 122, 003, "7",oDlg,{||oPM("7")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 122, 043, "8",oDlg,{||oPM("8")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 122, 083, "9",oDlg,{||oPM("9")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 122, 123, "*",oDlg,{||oPM("*")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 148, 003, "4",oDlg,{||oPM("4")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 148, 043, "5",oDlg,{||oPM("5")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 148, 083, "6",oDlg,{||oPM("6")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 148, 123, "-",oDlg,{||oPM("-")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    TButton():New( 174, 003, "1",oDlg,{||oPM("1")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 174, 043, "2",oDlg,{||oPM("2")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 174, 083, "3",oDlg,{||oPM("3")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 174, 123, "+",oDlg,{||oPM("+")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    
    TButton():New( 200, 003, "+/-",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 200, 043, "0",oDlg,{||oPM("0")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 200, 083, ",",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 200, 123, "=",oDlg,{||oPM("=")}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )

    oDlg:Activate(,,,.T.,,,EnchoiceBar(oDlg,{||oDlg:End()} ,{|| oDlg:End() }))


Return

//C�lculo Matem�tico

Static Function oPM(cVlr)
    
    If cVlr == "+"
        cOperat := "+"
    ElseIf cVlr == "-"
        cOperat := "-"
    ElseIf cVlr == "*"
        cOperat := "*"
    ElseIf cVlr == "/"
        cOperat := "/"
    ElseIf cVlr == "="
        cOperat := "="
    ElseIf cVlr == "C"
        cOperat := "C"
    ElseIf cVlr == ""
        cOperat := ""
    EndIf

    If cOperat == ""
        cValor1 += cVlr
        cRest := cValor1 + cValor2
        nOprF := VAL(cValor1) + VAL(cValor2)
    ElseIf cOperat == "+"
        cValor2 += cVlr
        cRest := cValor1 + cValor2
        nOprF := VAL(cValor1) + VAL(cValor2)
    ElseIf cOperat == "-"
        cValor2 += cVlr
        cRest := cValor1 + cValor2
        nOprF := VAL(cValor1) + VAL(cValor2)
    ElseIf cOperat == "*"
        cValor2 += cVlr
        cRest := cValor1 + cValor2
        nOprF := VAL(cValor1) + VAL(cValor2)
    ElseIf cOperat == "/"
        cValor2 += cVlr
        cRest := cValor1 + cValor2
        nOprF := VAL(cValor1) + VAL(cValor2)
    ElseIf cOperat == "="
        cRest := cValor1 + cValor2
        nOprF := VAL(cValor1) + VAL(cValor2)
    ElseIf cOperat == "C"
        cValor1 := ""
        cValor2 := ""
        cRest := "0"
        nOprF := 0
        cVlr := ""
    EndIf
    
Return
