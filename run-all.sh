#!/bin/bash
iverilog -o tb *.v 
rm -f saida.out 
./tb > saida.out 
grep -oE '\b(OK|ERRO)\b' saida.out
