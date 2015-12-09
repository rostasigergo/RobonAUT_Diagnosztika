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

 @section A Rendszer működése:

A robot magától nem kommunikál a programmal, a kommunikációt mindíg a program kezdeményezi. A felhasználói felület frissítése is úgy történik,
hogy beállítható, hogy a felhasználói felület milyen gyakorisággal kérje le a robot információit, vagy küldjön utasítást.
Ilyenkor a robotproxy osztály dolgozik.
Elsőként **ellenőrzi hogy megvan-e a robot** a COM port tulsó végén, ehhez egy beköszönő üzenetet küld, amire a robot válaszol.
Amennyiben **adatot** kérünk le a


  @section HMI HMI: Megjelelnítő felület

Program rendelkezik egy QML-ben készült felhasználói felülettel is.
 A main() függvényben történik a fent említett osztályok példányosítása kommunikáció, robotproxy, robotstatehistory, (a history és a komm a proxyn belül)
    ezek signal - slot mechanizmuson kereszül kapcsolódnak a QML felülethez ahol az adatok megjelenítése történik.

![](HMI.jpg)

  * A képen a HMI látható, jobb oldalt az autó sebessége és az első tengely irányvektora,
  felette az első és hátsó vonalszenzorsor adatai, jobb oldalt a csatlakozáshoz és parancskiadáshoz való beavatkozók
  középen pedi az event log látható.

  @section Kommunikáció
  A program a robottal egyszerű szöveges parancsok segítségével kommunikál, amelyekre a robot válaszol.

 | Parancs       | Válasz        |
 | ------------- |---------------|
 | HELLO         | HELLO_ACK     |
 | DATAREQ       | STATUS        |
 | COMMAND xy    | COMMAND_ACK   |

A kommunikáció menete a következő:

A robotproxy osztály a timer hatására küld egy kérést a communiation osztálynak ami a COM-on keresztül továbbítja az üzenetet a robotnak.

A robot minden esteben egy üzenetcsomaggal válaszol aminek első tagja a csomag mérete, majd egy kód ami tartalmazza a robot üzenetét, majd ha vannak az adataok.
Ezt a fogadó oldalon feldolgozzuk és megjlenítjük a HMI-n.


@section Státuszok

A Robot lehetséges státuszai:

* Manuális
* Autonóm - Indításra vár
* Autonóm - Vonalkövetés OK
* Autonóm - Nincs vonal
* Autonóm - Ütközés

 @section Robot Robot:
  A robot központi vezérlpje egy STM32F4 panelen található, ezen fut egy FreeRTOS operációs rendszer

