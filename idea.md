# Game Design Document

## 1. Přehled hry
**Pracovní název:** Daně z Existence  
**Žánr:** Temný psychologický horor s prvky karetní strategie a risk-managementu.  
**Platforma:** PC (Engine: Godot)  
**Atmosféra:** Klaustrofobická, beznadějná, industriálně-groteskní.

## 2. Příběhové pozadí
Hráč se ocitá v "Meziprostoru Kapitálu" – nekonečné, prázdné kanceláři bez oken, kde čas neplyne lineárně. Naproti němu sedí **Bůh kapitálu**: entita složená z nekonečných vrstev drahých látek, mince místo očí a hlasu, který zní jako drcení kostí a cinkání zlata.

Bůh kapitálu nevlastní peníze, on *je* hodnota. Aby hráč mohl postoupit dále nebo vykoupit svou svobodu, musí prokázat svou cenu v rituální hře. Protože v prázdnotě nemají peníze váhu, jedinou měnou, kterou Bůh přijímá, je fyzická integrita dlužníka.

## 3. Herní mechaniky

### 3.1. Rituál o jednadvaceti (Základní smyčka)
Hra vychází z principu sčítání hodnot karet k cílovému číslu 21. Hráč hraje proti Bohu (Krupiérovi). 
* **Cíl:** Dosáhnout součtu co nejbližšího 21, ale nepřekročit ho.
* **Napětí:** Každé kolo není jen o vítězství v partii, ale o přežití následků prohry.

### 3.2. Tělesná lichva (Sázky)
Namísto žetonů hráč sází své vlastní tělo. Každá sázka má svou "úrokovou sazbu" a dopad na hratelnost:
* **Oko (Zrak):** Ztráta oka způsobí vizuální glitch v rozhraní, ztíží odhadování hodnot skrytých karet nebo rozmaže texty artefaktů.
* **Ruka (Manipulace):** Ztráta prstů či celé ruky snižuje počet karet, které může hráč držet, nebo omezuje možnost používat pomocné předměty.
* **Krev (Životní síla):** Slouží jako hlavní ukazatel zdraví. Každá prohra odčerpá určité množství mililitrů. Nulový stav znamená pohlcení duše Bohem kapitálu.
* **Noha (Stabilita):** Symbolizuje možnost ústupu. Ztráta nohy znemožňuje hru předčasně ukončit a odejít s malým ziskem – hráč je pak nucen dohrát "všechno, nebo nic".

### 3.3. Relikvie a modifikátory
V průběhu hry hráč získává (nebo si za cenu další bolesti kupuje) relikvie, které ohýbají pravidla:
* **Prokletá mince:** Umožní nahlédnout na další kartu v balíčku, ale za cenu náhodného poškození zraku.
* **Zlatá svorka:** Umožní "sepnout" dvě karty dohromady a brát je jako jednu hodnotu.
* **Dlužní úpis:** Zdvojnásobí sázku v příštím kole, ale při výhře vrátí jednu z dříve obětovaných částí těla.

## 4. Technické zpracování
* **Engine:** Godot (využití efektivního 2D/3D renderování pro detailní textury masa a kovu).
* **Vizuální styl:** Low-fidelity (retro) estetika s moderními post-procesovými efekty. Důraz na detailní animace rukou a karet.
* **Sound design:** Absence hudby. Dominují zvuky mechanických hodin, skřípění pera o papír, těžké dýchání a zvuk trhání tkáně při prohře.

## 5. Průběh hry (Game Flow)
1.  **Konfrontace:** Dialog s Bohem kapitálu, volba obtížnosti (výše dluhu).
2.  **Sázková fáze:** Výběr části těla, kterou hráč v daném kole riskuje.
3.  **Herní fáze:** Tahání karet, používání modifikátorů.
4.  **Exekuce/Odměna:** Pokud hráč prohraje, následuje animace "splátky" (ztráta části těla). Pokud vyhraje, získává výhodu nebo postup do dalšího patra kanceláře.
5.  **Finále:** Konečné vyúčtování. Hráč buď splatí dluh (vítězství), nebo se stane součástí inventáře Boha kapitálu (prohra).
