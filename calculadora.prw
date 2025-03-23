/*+=================================+
|Programa: Rotina que irá centralizar todas as informações pertinentes ao Recrutamento e Seleção de Pessoas amarrando assim com o Budget
|Autor: Elker G.B.
|Data criação: 20/01/2025
|###
|Versão     |Data           |Funcionalidades
|0.0.0      |20/01/2025     | Desenvolvimento inicial contemplando vínculo com BGT(tabela ZZO classe QDPESS)
|           |               |   campos anonimizados, como nome, telefone, CPF
|           |               |   demais campos seriam Previsão Admissão, CC, Função, Obeservações, Status
|           |               |   vinculo futuro com Competência e GHE
|1.0.0      |               | Colocado em operação com:
|           |26/02/2025     |   atendimento as Abas Ata/Solcitação
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
    TButton():New( 096, 043, "x²",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 096, 083, "²Vx",oDlg,{||}, 37,23,,,.F.,.T.,.F.,,.F.,,,.F. )
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

//Cálculo Matemático

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
