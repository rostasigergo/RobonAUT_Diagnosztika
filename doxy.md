 @mainpage TimeAUT fedélzeti diagnosztikai rendszer

 @tableofcontents

 @section Architektura Architektura átekintés

 A Diagnosztikai rendszer négy központi elemből áll:

 * **Communication**
 Ez felelős a program és a fogadó oldal közötti **kommunikációért**, soros portra lett megvalósítva.

 * **RobotState**
 Ez az osztály tárolja a robot **változóit**, ebben van reprezentálva az összes szenzoradat.

 * **RobotProxy**
 Ez az osztály végzi a robot progam felé történő interfacelését, ez az osztály tartja kapcsolatban a kommunikációt
 az adatok tárolásával és ezen kereszül történik a **parancsok kiadása** is.
 Ezen kívül robotproxy osztály végzi a C++ oldal vezérlését, itt példányosodik a Communication és a RobotStateHistory is

 * **RobotStateHistory**
 A robot által **visszaküldött állapotok tárolására** szolgál , itt lehet visszakeresni a korábbi szenzorképeket is,
 illetve ennek a tartalmát jeleníti meg a felhasználói felület. (visszakereshető jeleggel)

  @section HMI HMI: Megjelelnítő felület

 Ezen felül van a programnak egy QML-ben készült felhasználói felülete is.
 A main() függvényben történik a fent említett osztályok példányosítása (kommunikáció, robotproxy, robotstatehistory),
    ezek signal - slot mechanizmuson kereszül kapcsolódnak a QML felülethez ahol az adatok megjelenítése történik.

![](HMI.jpg)

  * A képen a HMI látható, jobb oldalt az autó sebessége és az első tengely irányvektora,
  felette az első és hátsó vonalszenzorsor adatai, jobb oldalt a csatlakozáshoz és parancskiadáshoz való beavatkozók
  középen pedi az event log látható.

     @section Kommunikáció
        A program a robottal egyszerű szöveges parancsok segítségével kommunikál, amelyekre a robot válaszol.

        | Parancs       | Válasz        |
        | ------------- |---------------|
        | HELLO         | ACK           |
        | DATAREQ       | szenzoradatok |
        | COMMAND xy    | xy ACK        |

A kommunikáció menete a következő:

bÉLA ÁTKIABÁL A SZOMSZÉDBA

**sequence**
Alice->Bob: Hello Bob, how are you?
Note right of Bob: Bob thinks
Bob-->Alice: I am good thanks!



Ezen kommunikációt a Robotproxy osztály irányítja

 @section Robotproxy Robotproxy:

 @section Robot Robot:
  A robot központi vezérlpje egy STM32F4 panelen található, ezen fut egy FreeRTOS operációs rendszer

