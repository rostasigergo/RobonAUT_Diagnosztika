 @mainpage TimeAUT fedélzeti diagnosztikai rendszer

 @tableofcontents

 @section Architektura Architektura átekintés

 A Diagnosztikai rendszer négy központi elemből áll:

        Kommunikációs osztály:
        Ez felelős a program és a fogadó oldal közötti kommunikációért, soros portra lett megvalósítva.

        Robotstate osztály:
        Ez az osztály tárolja a robot változóit, ebben van reprezentálva az összes szenzoradat.

        Robotproxy osztály:
        Ez az osztály végzi a robot progam felé történő interfacelését, ez az osztály tartja kapcsolatban a kommunikációt
        az adatok tárolásával és ezen kereszül történik a parancsok kiadása is.

        Robotstatehistory osztály:
        A robot által visszaküldött állapotok tárolására szolgál , itt lehet visszakeresni a korábbi szenzorképeket is,
        illetve ennek a tartalmát jeleníti meg a felhasználói felület. (visszakereshető jeleggel)

 @section Kommunikáció
        A program a robottal egyszerű szöveges parancsok segítségével kommunikál, amelyekre a robot válaszol.

        | Parancs       | Válasz        |
        | ------------- |:-------------:|
        | HELLO         | ACK           |
        | DATAREQ       | szenzoradatok |
        | zebra stripes | are neat      |

        Ezen kommunikációt a Robotproxy osztály végzi.


 @section Robot Robot:
  A robot központi vezérlpje egy STM32F4 panelen található, ezen fut egy FreeRTOS operációs rendszer

 @section HMI HMI: Megjelelnítő felület
