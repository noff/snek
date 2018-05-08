# README

## Install

```
bundle 
```

## Run website

```
rails s
```

## Development plan

Here: https://github.com/noff/snek/projects/1 


## Редактор змеи

Если выбрать инструмент, то при клике на ячейку этот инструмент проставится в эту ячейку. По-умолчанию в логическом режиме AND.
Если выбрать инструмент NOT, то текущий инструмент будет ставиться в ячейку в режиме NOT.
Если расставить несколько ячеек в режиме OR, то паттерн сработает, если хотя бы один OR совпадет.



## Базовое расположение змей на поле боя

```

     00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26	
00 | WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW
01 | WW                                                                            WW
02 | WW                                     T0                                     WW
03 | WW                                     B0                                     WW
04 | WW                                     B0                                     WW
05 | WW                                     B0                                     WW
06 | WW                                     B0                                     WW
07 | WW                                     B0                                     WW
08 | WW                                     B0                                     WW
09 | WW                                     B0                                     WW
10 | WW                                     B0                                     WW
11 | WW                                     H0                                     WW
12 | WW                                                                            WW
13 | WW    T3 B3 B3 B3 B3 B3 B3 B3 B3 H3          H1 B1 B1 B1 B1 B1 B1 B1 B1 T1    WW
14 | WW                                                                            WW
15 | WW                                     H2                                     WW
16 | WW                                     B2                                     WW
17 | WW                                     B2                                     WW
18 | WW                                     B2                                     WW
19 | WW                                     B2                                     WW
20 | WW                                     B2                                     WW
21 | WW                                     B2                                     WW
22 | WW                                     B2                                     WW
23 | WW                                     B2                                     WW
24 | WW                                     T2                                     WW
25 | WW                                                                            WW
26 | WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW WW
```