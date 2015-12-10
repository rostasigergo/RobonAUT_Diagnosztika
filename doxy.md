 @mainpage TimeAUT fedélzeti diagnosztikai rendszer

 @tableofcontents

 @section Architektura Architektura átekintés

@see A Rendszer működése

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

A timer hatására a RobotProxy osztály a friissítés során a RobotProxy osztály kap egy
Elsőként **ellenőrzi hogy megvan-e a robot** a COM port tulsó végén (isOnline()), ehhez egy beköszönő üzenetet küld, amire a robot válaszol. @see Kommunikáció

Ezután minden timer híváskor a RobotProxy küld egy send(DATAREQUEST) hívást a Communicationnak , továbbküldi a robotnak.
A robot válasza után (mikor az egész üzenet megjött) a communication kiadja az msgReady() signalt, ennek hatására a RobotProxy földolgozza a recieve streamból az adatokat
beteszi őket egy RobotState-ba, amit bepushol a RobotStateHistory-ba. A RobotStateHistory a változásáról a historyCHnaged() signalon kereszül jelez a HMI-nek, ami enne hatására 
átáll az utolsó elemre a RobotStateHistory-ban.

Korábbi állapotok visszakeresésénél pedig a History tömb korábbi elemeire heéyezzük át a mutatót.

![](UMLdiag.png)


  @section HMI HMI: Megjelelnítő felület

Program rendelkezik egy QML-ben készült felhasználói felülettel is.
 A main() függvényben történik a fent említett osztályok példányosítása kommunikáció, robotproxy, robotstatehistory, (a history és a komm a proxyn belül)
    ezek signal - slot mechanizmuson kereszül kapcsolódnak a QML felülethez ahol az adatok megjelenítése történik.

![](HMI.jpg)

  * A képen a HMI látható, jobb oldalt az autó sebessége és az első tengely irányvektora,
  felette az első és hátsó vonalszenzorsor adatai, jobb oldalt a csatlakozáshoz és parancskiadáshoz való beavatkozók
  középen pedig az event log látható.

A HMI frissítése a beérkező adatok függvényében történik, azonban adat csak kérésre érkezik.

 @section használat A program használata:
 * Indítás után a fő képernyő fogad minket, itt a bal felső menüben van lehetőségünka  robothoz való csatlakozásra illetve kilépésre.
 * A menü fülön a **COM kiválaszása** gomb megynomása után felugrik egy ablak amiben a legördülő listából kiválasztható az összes a géphez kapcsolódó soros port.
 * A kívánt port kiválasztása után ugyanebben a menüben található **Csatlakozás...** gombal tudunk a robothoz kapcsolódni.
 * Ekkor a jobb felül lévő info panelen látható hogy meg is változik a kapcsolatunk státusza (amennyiben a robot megfelelően válaszolt).
 * Ezután aktiválódnak a **kapcsolat ellenőrzése** és **kapcsolat bontása** menüpontok is.
 * Az **adatok frissítéséhez kiválaszthatjuk a frissítési** sebességet a legördülő listából majd ezután az **Adatok frissítése** gombot néhány másodpercig lenyomva tartva elindul az automatikus frissítés.
 * Az efelett a menü felett található **Gyorsítás** , **Lassítás** , **Jobbra** , **Balra** gombok a robot vezérlésére szolgálnak.
 * Amennyiben elindítottuk az automata frissítést a kijelzőkön mindíg a legfrisebb adatok jelennek meg, és a központi logban láthatóak a beérkezett állapot csomagok.
 * Ha valamelyik régebbi csomag tartalmára vagyunk kíváncsiak a kör alakú nyomógomb alatti **online** checkbox kikattintásával lehetőségünk nyílika  log listában egy **korábbi állapot kiválasztására** amely adatai ekkor megjelennek a kijelzőn
 * Az **online checkbox** visszakattintásával újra a legfrisebb adatok kerülnek megjelenítésre.
 * Ezen felül a jobb oldali **Mutatós műszerek** alatt kiválasztató, hogy milyen mértékegységben jelződjön ki a sebesség (illetve a fordulatszám)
 * A Jobb felső menüben ezen kívül lehetőségünk van még a **Beállítások** fülön az **áttételek** és a **kerékátmérő** megadására
 @warning A kerékátmérő és az áttétel hibás beállítása a sebesség hibás kijelzését eredményezi

![](UPDATE.png)

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

![](KOMM.png)

@section Státuszok

A Robot lehetséges státuszai:

* Manuális
* Autonóm - Indításra vár
* Autonóm - Vonalkövetés OK
* Autonóm - Nincs vonal
* Autonóm - Ütközés

@warning Manuálisból autonómba álláskor a szervó és a gáz is nullába áll vissza !

 @section Robot Robot:

  A robot központi vezérlője egy STM32F4 panelen található, ezen fut egy FreeRTOS operációs rendszer, ezen vannak implementálva
  a robot vezérlőszervei. Sajnos időhiány miatt a rendszer nem lett kész így a robot a tényleges mozgást csak szimulálja, de
  az STM32 ben minden adat rendelkezésre áll ami a valós robotban is ott lenne.

@Warning A robot a bemeneti parancsokra hirtelen reagál, ez azért van mert az STM ben jelenlege gy szimulátor fut, ami ugrásszerűen változtatja a sebesség érékeket

@section Video Video a programról

[TimeAUT telemetria](https://youtu.be/qujEQ3mOBeo)

A fenti videóban található a program ismertetése.

@section Branchek Branchek

Az alábbi képeken pedig a fejlesztési folyamat látható:

![](branches2.jpg)
![](branches1.jpg)
![](branches0.jpg)


