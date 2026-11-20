# visionOS Minigolf – Projektplan

## 1. Projektübersicht

### Ziel
Entwicklung einer kleinen Mixed-Reality-Minogolf-Anwendung für visionOS. Die erste Version soll innerhalb weniger Minuten erlebbar sein und zunächst nur die grundlegenden Spielelemente enthalten.

Beim Start erscheint ein großer, nutzerrelativ am Immersive-Space-Ursprung vor dem Spieler schwebender Hebel. Der Spieler greift den Hebel mit der Hand (bzw. per Maus im Simulator) und zieht ihn nach unten. Sobald der Hebel einen definierten Auslösewinkel erreicht, erscheint ein einfaches Minigolf-Setup mit:

- einem Golfschläger (Putter),
- einem Golfball,
- einem Golfloch,
- einer einfachen grünen Spielfläche.

Die erste Version benötigt weder Raumerkennung noch Hindernisse oder eine automatisch generierte Strecke. Diese Funktionen sind für spätere Ausbaustufen vorgesehen.

### Technischer Rahmen

- **Plattform:** Apple visionOS
- **Deployment Target:** visionOS 26.0 (im bestehenden Xcode-Projekt bereits gesetzt; damit sind alle benötigten RealityKit-APIs verfügbar)
- **Entwicklungsumgebung:** Xcode
- **Programmiersprache:** Swift
- **3D-Darstellung und Interaktion:** RealityKit
- **UI und App-Struktur:** SwiftUI
- **Projektbasis:** Das bestehende Projekt `Minigolf_Simulator/Minigolf_Simulator.xcodeproj` wird als Grundstruktur verwendet. Vorhandene Immersive-Space-Router, `RealityView`-Beispiele und `HoverRotateModifier.swift` (`InputTargetComponent` + `DragGesture`) werden wiederverwendet. Inhalte, die für Minigolf nicht benötigt werden (alte Labs, nicht verwendete Assets), werden entfernt.
- **Testgeräte:** Ein physisches visionOS-Gerät ist verfügbar. Zusätzlich wird ein expliziter **Maus-/Trackpad-Fallback** für den Simulator eingeplant, damit die Interaktion ohne Hände entwickelt und geprüft werden kann.
- **3D-Assets im MVP:** Ausschließlich RealityKit-Grundformen (Sphere, Box, Cylinder, Torus/Ring). USDZ-Modelle sind erst für spätere Ausbaustufen vorgesehen.
- **Modellquellen später:** Reality Composer Pro, Sketchfab und andere Asset-Bibliotheken; Lizenzen vor Import prüfen.

### Grundprinzip
Die Anwendung wird in kleine, voneinander getrennte Komponenten aufgeteilt. Sie werden in die bestehende App-Struktur eingegliedert, statt ein neues Projekt anzulegen. Dadurch können später Raumerkennung, Physik, Hindernisse und Streckengenerierung ergänzt werden, ohne die Grundstruktur neu entwickeln zu müssen.

---

## 2. Umfang der ersten Version (MVP)

### Enthalten

| Bestandteil | Beschreibung |
|---|---|
| Immersive Szene | Eine Mixed-Reality-Szene, in der die reale Umgebung sichtbar bleibt |
| Start-Hebel | Ein großer Hebel schwebt nutzerrelativ am Immersive-Space-Ursprung vor dem Spieler (~1,2 m, leicht unter Augenhöhe) |
| Handinteraktion | Der Spieler kann den Hebel greifen und nach unten ziehen; Maus-/Trackpad-Drag als Simulator-Fallback |
| Auslösebedingung | Beim Erreichen eines Winkels von ~60° an der X-Achse wird das Setup erzeugt |
| Spielfläche | Eine einfache grüne Fläche als visuelle Grundlage |
| Golfschläger | Ein aus RealityKit-Grundformen zusammengesetzter Putter |
| Golfball | Eine RealityKit-Sphere |
| Golfloch | Eine einfache dunkle Öffnung mit sichtbarem Ring-Rand |
| Platzierung | Alle Spielelemente erscheinen unter `setupRoot` in einer fest definierten Anordnung |

### Nicht Bestandteil der ersten Version

- Automatische Erkennung von Boden, Wänden oder Möbeln
- Automatische Anpassung der Strecke an den realen Raum
- Modulare oder zufällig generierte Hindernisse
- Mehrere Bahnen oder Level
- Vollständige Golf-Physik und realistische Ballbewegung
- Punktesystem, Bestenliste oder Mehrspielerfunktion
- Aufwendige Menüs und Einstellungen

Diese Punkte können nach Fertigstellung und Test des MVP schrittweise ergänzt werden.

---

## 3. Geplanter Ablauf aus Sicht des Spielers

1. Der Spieler startet die Anwendung.
2. Die Mixed-Reality-Szene wird geöffnet.
3. Vor dem Spieler erscheint ein großer, schwebender Hebel.
4. Der Spieler greift den Hebel mit der Hand.
5. Er zieht den Hebel nach unten.
6. Sobald der Auslösepunkt erreicht ist (≈ 60°), wird die Aktivierung ausgelöst.
7. Der Hebel bleibt sichtbar und kehrt in seine Ausgangsposition zurück, damit er erneut gezogen werden kann.
8. Die grüne Spielfläche, der Putter, der Ball und das Loch erscheinen.
9. Der Spieler kann die Minigolf-Szene betrachten und als nächsten Entwicklungsschritt mit dem Spielen beginnen.
10. Zieht der Spieler den Hebel erneut nach unten, wird das Setup entfernt und der Zustand auf `ready` zurückgesetzt – der Ablauf kann beliebig oft wiederholt werden.

---

## 4. Schritt-für-Schritt-Implementierungsplan

### Phase 0 – Technische Entscheidungen absichern

**Ziel:** Die offenen technischen Fragen klären, bevor Implementierungscode entsteht.

Aufgaben:
- Deployment Target prüfen: im bestehenden Projekt bereits auf visionOS 26.0 gesetzt, keine Änderung nötig.
- Bestehendes Projekt öffnen und Inventar aufnehmen: welche Labs/Assets werden entfernt, welche bleiben als Vorlage.
- Drag-Interaktion an einer Test-Entity nachweisen (bestehender `HoverRotateModifier` als Basis, Maus-Fallback im Simulator).
- Kamera-relative Platzierung und ein gemeinsames `setupRoot` verifizieren.
- Winkelmodell (0° → 60°, Rotation um X-Achse) und Reset per erneutem Zug festschreiben.

**Ergebnis:** Alle technischen Grundentscheidungen sind dokumentiert und kurz verifiziert.

### Phase 1 – Projekt einrichten

**Ziel:** Die bestehende visionOS-App als lauffähige Grundlage für Minigolf vorbereiten.

Aufgaben:
- Bestehendes Projekt `Minigolf_Simulator.xcodeproj` in Xcode öffnen.
- Nicht benötigte Labs, Assets und Abhängigkeiten entfernen; Immersive-Space-Router und `RealityView`-Vorlagen behalten.
- Neue Route/neuen Lab-Eintrag für Minigolf anlegen (statt eigenständiger App).
- Einen Immersive Space für Minigolf einrichten.
- Eine `RealityView` in die Szene einbinden.
- Eine einfache Test-Entity erzeugen und anzeigen.
- Auf Simulator (Maus-Fallback) und visionOS-Gerät testen.

**Ergebnis:** Die bestehende App öffnet eine Minigolf-Mixed-Reality-Szene und zeigt mindestens ein 3D-Objekt an.

### Phase 2 – Hebel erstellen und platzieren

**Ziel:** Der Hebel ist sichtbar und sinnvoll in der Szene positioniert.

Aufgaben:
- Den Hebel aus RealityKit-Grundformen zusammensetzen: fester Träger (Cylinder/Box) und beweglicher Griff.
- Den Drehpunkt festlegen: Rotation des Griffs um die X-Achse, Bereich 0°–60°.
- Kamera-relative Platzierung: etwa 1,2 m vor der Kamera, leicht unter Augenhöhe.
- Größe, Ausrichtung und Sichtbarkeit in der Mixed-Reality-Umgebung prüfen.
- Den Hebel nach jeder Auslösung in die Ausgangsposition zurückführen, damit er erneut greifbar bleibt.

**Ergebnis:** Beim Start der immersiven Szene schwebt ein vollständiger Hebel vor dem Spieler, ist um die X-Achse drehbar und kehrt nach der Auslösung selbstständig zurück.

### Phase 3 – Hebel mit der Hand greifen und bewegen

**Ziel:** Der Spieler kann den Hebel tatsächlich greifen und nach unten ziehen.

Aufgaben:
- Die benötigten RealityKit-Komponenten für Eingabe und Interaktion einrichten (`InputTargetComponent`, Kollisionsformen, Hover-Effekt).
- Den beweglichen Griff als interaktives Objekt vorbereiten; Vorlage: `HoverRotateModifier.swift`.
- Handbasierte Drag-Interaktion auf dem Gerät und Maus-/Trackpad-Drag als Simulator-Fallback implementieren.
- Die Bewegung auf die Rotation um die X-Achse beschränken (0°–60°).
- Den aktuellen Winkel auswerten und den Auslösepunkt bei ≈ 60° festlegen.
- Ein `hasTriggered`-Flag **pro Zyklus** verwenden, damit ein Zug genau ein Ereignis auslöst.
- Nach der Auslösung den Hebel zurückfedern lassen und das Flag erst beim Reset zurücksetzen.
- Den zweiten Zug als Reset-Signal verwenden (Setup entfernen, Zustand `ready`).

**Ergebnis:** Der Hebel lässt sich mit der Hand (Gerät) bzw. Maus (Simulator) greifen und nach unten ziehen. Beim Erreichen von ≈ 60° wird genau ein Aktivierungsereignis ausgelöst; der nächste Zug löst den Reset aus.

### Phase 4 – Minigolf-Objekte erstellen und platzieren

**Ziel:** Nach der Hebelbetätigung erscheint ein einfaches Minigolf-Setup.

Aufgaben:
- Eine einfache grüne Spielfläche aus einer RealityKit-Box erstellen.
- Den Golfball als RealityKit-Sphere erzeugen.
- Den Putter zunächst aus einfachen Formen (Cylinder + Box) zusammensetzen.
- Das Golfloch mit dunkler Öffnung und sichtbarem Ring-Rand (Torus) gestalten.
- Eine feste Anordnung und Abstände zwischen Ball, Schläger und Loch definieren.
- Alle Objekte unter einem gemeinsamen `setupRoot` platzieren (nutzerrelativ am Immersive-Space-Ursprung, gleiche Basis wie der Hebel).
- Die Objekte erst nach erfolgreicher Hebelbetätigung zur Szene hinzufügen und beim Reset als Gruppe entfernen.

**Ergebnis:** Nach der Aktivierung erscheinen Spielfläche, Putter, Ball und Loch in einer zusammenhängenden Anordnung unter `setupRoot`; beim Reset verschwinden sie gemeinsam.

### Phase 5 – Zustände und Szenenablauf sauber organisieren

**Ziel:** Der Ablauf ist nachvollziehbar und kann später erweitert werden.

Aufgaben:
- Einen zentralen Spielzustand definieren: `ready`, `activating`, `setupCreated`.
- Die Zustandswechsel im `GameManager` verwalten.
- Die Erzeugung der Spielelemente von der Hebelinteraktion trennen.
- Doppelte Erzeugung von Objekten durch das zyklische `hasTriggered`-Flag verhindern.
- Reset per erneutem Hebelzug implementieren: `setupRoot` entfernen, Hebel in Ausgangsposition zurücksetzen, Winkel auf 0° und `hasTriggered` auf `false` setzen, Zustand `ready`.
- Kein separater UI-Button nötig – der Hebel bleibt das einzige Interaktionsobjekt.

**Ergebnis:** Die App besitzt einen klaren, beliebig oft wiederholbaren Ablauf; die Komponenten sind nicht unnötig voneinander abhängig.

### Phase 6 – Testen und Präsentation vorbereiten

**Ziel:** Die Anwendung funktioniert zuverlässig und kann in einer kurzen Demonstration gezeigt werden.

Aufgaben:
- Start und Öffnen des Immersive Space auf Simulator und Gerät testen.
- Sichtbarkeit und nutzerrelativ am Immersive-Space-Ursprunge Position des Hebels prüfen.
- Greifen und Herunterziehen mit der Hand auf dem Gerät testen.
- Maus-/Trackpad-Fallback im Simulator ausführlich testen (verschiedene Ausgangspositionen, Winkelgrenzen).
- Prüfen, ob der Auslösepunkt bei ≈ 60° zuverlässig erkannt wird.
- Prüfen, ob alle Spielelemente korrekt erscheinen und der Reset per zweitem Zug funktioniert.
- Größen, Abstände und Materialien verbessern.
- Nicht benötigte Reste des alten Projekts und unnötige Debug-Elemente entfernen.
- Eine kurze Demonstrationsabfolge festlegen (Start → Zug → Setup → Reset).

**Ergebnis:** Eine stabile, visuell verständliche Minigolf-Grundszene, die auf Gerät und Simulator beliebig oft in einer kurzen Präsentation vorgeführt werden kann.

---

## 5. Vorgeschlagene Projektstruktur

Die Struktur baut auf dem bestehenden Xcode-Projekt auf. Nicht benötigte Labs und Assets werden entfernt; vorhandene Vorlagen (`visionOSLecturesApp.swift`, Immersive-Space-Router, `HoverRotateModifier.swift`) bleiben erhalten.

```text
Minigolf_Simulator/
├── Minigolf_Simulator.xcodeproj
│
└── visionOS Lectures/
    ├── visionOSLecturesApp.swift        (bestehend, Router beibehalten)
    │
    ├── App/
    │   └── Views/
    │       ├── LabDetail.swift          (bestehend, Router)
    │       └── LabList.swift            (bestehend, auf Minigolf-Eintrag reduzieren)
    │
    ├── Labs/
    │   └── LabMinigolf.swift            (neu – Einstieg in die Szene)
    │
    ├── Game/
    │   ├── GameManager.swift            (neu – Ablauf, Setup, Reset)
    │   └── GameState.swift              (neu – ready / activating / setupCreated)
    │
    ├── Entities/
    │   ├── LeverEntity.swift            (neu – Träger + drehbarer Griff)
    │   ├── GolfClubEntity.swift         (neu – Putter aus Grundformen)
    │   ├── GolfBallEntity.swift         (neu – Sphere)
    │   ├── GolfHoleEntity.swift         (neu – Öffnung + Ring)
    │   └── GolfSurfaceEntity.swift      (neu – grüne Fläche)
    │
    ├── Interaction/
    │   └── LeverInteraction.swift       (neu – Drag, Winkel, Auslösung, Reset)
    │
    ├── Modifier/
    │   └── HoverRotateModifier.swift    (bestehend – Vorlage für Drag-Interaktion)
    │
    └── Model/
        └── DirectoryModel.swift         (bestehend – auf Minigolf-Eintrag reduziert)
```

### Aufgaben der wichtigsten Dateien

| Datei | Verantwortung |
|---|---|
| `visionOSLecturesApp.swift` | App-Einstiegspunkt und Verwaltung des Immersive Space (bestehend) |
| `LabMinigolf.swift` | Aufbau und Darstellung der `RealityView` für Minigolf |
| `GameManager.swift` | Steuert Zustandswechsel, Erzeugung und Entfernung des Setups sowie Reset |
| `GameState.swift` | Enthält die möglichen Zustände `ready`, `activating`, `setupCreated` |
| `LeverEntity.swift` | Erstellt den Hebel mit Drehpunkt und Rückführbewegung |
| `LeverInteraction.swift` | Verarbeitet Hand-/Maus-Drag, Winkelauswertung, Auslösung und Reset-Signal |
| `GolfClubEntity.swift` | Erstellt den Putter aus RealityKit-Grundformen |
| `GolfBallEntity.swift` | Erstellt den Golfball als Sphere |
| `GolfHoleEntity.swift` | Erstellt Lochöffnung und sichtbaren Rand |
| `GolfSurfaceEntity.swift` | Erstellt die grüne Spielfläche |

---

## 6. Umgang mit 3D-Modellen und Assets

**Für den MVP gilt: keine externen Modelle.** Alle Objekte werden aus RealityKit-Grundformen erzeugt. Das vermeidet Lizenz-, Format- und Import-Risiken und macht die Szene sofort lauffähig. USDZ-Modelle und Reality Composer Pro sind erst für spätere Ausbaustufen vorgesehen.

### Bevorzugte Vorgehensweise (ab Erweiterung 1)

1. Zuerst nach geeigneten fertigen Modellen suchen.
2. Wenn möglich USDZ- oder USD-Dateien verwenden.
3. Lizenz und erlaubte Nutzung prüfen.
4. Modelle in Xcode bzw. Reality Composer Pro importieren.
5. Größe, Ausrichtung und Materialien kontrollieren.
6. Modelle bei Bedarf vereinfachen oder in Blender anpassen.

### Geplante Assets

| Objekt | MVP-Umsetzung | Später |
|---|---|---|
| Hebel | Cylinder/Box als Träger, separater drehbarer Griff | USDZ-Modell mit getrenntem Griff |
| Golfball | RealityKit-Sphere | USDZ-Modell mit Detailtextur |
| Golfschläger | Cylinder (Schaft) + Box (Schlägerkopf) | Fertiges Putter-Modell |
| Golfloch | Dunkle Scheibe + Torus als Rand | Modell mit echter Geometrie |
| Spielfläche | RealityKit-Box, grünes Material | Texturierte Fläche |

Für den Hebel ist besonders wichtig, dass der bewegliche Griff getrennt vom festen Teil positioniert und bewegt werden kann. Die Aufteilung in `LeverEntity` (Träger) und Kind-Entity (Griff) ist daher schon im MVP verbindlich.

---

## 7. Technische und konzeptionelle Entscheidungen

| Thema | Entscheidung für den MVP |
|---|---|
| Darstellung | Mixed Reality; reale Umgebung bleibt sichtbar |
| Projektbasis | Bestehendes `Minigolf_Simulator.xcodeproj`, ungenutzte Inhalte entfernen |
| Deployment Target | visionOS 26.0 (bereits im Projekt gesetzt) |
| Platzierung | Kamera-relativ, ~1,2 m vor der Kamera, leicht unter Augenhöhe; Setup unter `setupRoot` |
| Hebelbewegung | Rotation um die X-Achse, 0°–60°, danach Rückführung in Ausgangsposition |
| Interaktionsart | Handbasierte Drag-Interaktion auf dem Gerät; Maus-/Trackpad-Drag als Simulator-Fallback |
| Auslösung | Winkel ≥ ~60°, `hasTriggered` pro Zyklus |
| Objekterzeugung | Erst nach erfolgreicher Hebelbetätigung; Entfernung beim Reset |
| Reset | Zweiter Hebelzug setzt Setup, Winkel und Zustand zurück – kein extra Button |
| 3D-Modelle | Ausschließlich RealityKit-Grundformen; USDZ erst später |
| Testung | Physisches visionOS-Gerät + Simulator mit Maus-Fallback |
| Raumerkennung | Erst in einer späteren Ausbaustufe |
| Hindernisse | Erst in einer späteren Ausbaustufe |

**Hinweis zur Interaktion:** Die konkrete Implementierung der Handinteraktion muss an die verwendete visionOS-Version und die verfügbaren RealityKit-APIs angepasst werden. Greifen, Ziehen, Kollisionsabfragen, Winkelbegrenzung und die Maus-/Trackpad-Variante sind eigene Implementierungsaufgaben und werden nicht automatisch durch das 3D-Modell bereitgestellt. Der bestehende `HoverRotateModifier` dient als Startpunkt.

**Hinweis zur Platzierung:** `AnchorEntity(.camera)` ist auf visionOS **nicht verfügbar**. Stattdessen wird der Immersive-Space-Ursprung als Bezugspunkt genutzt: Der Nutzer startet am Ursprung und blickt entlang -Z, eine Entity bei `[0, -0.15, -1.2]` liegt damit etwa 1,2 m vor ihm. Diese Root-Entity (`setupRoot`) wird auch für das Minigolf-Setup verwendet. (In Phase 0/1 verifiziert.)

---

## 8. Mögliche spätere Erweiterungen

Nach erfolgreicher Umsetzung des MVP kann das Projekt in folgenden Schritten ausgebaut werden:

### Erweiterung 1 – Ballphysik und Spielmechanik
- Ball mit dem Schläger bewegen.
- Kollisionen und Rollbewegung implementieren.
- Erkennen, wann der Ball im Loch landet.
- Einfache Schlag- und Versuchsanzahl ergänzen.

### Erweiterung 2 – Raumerkennung
- Reale Umgebung erfassen.
- Bodenflächen erkennen.
- Geeignete freie Bereiche für die Minigolf-Bahn bestimmen.
- Virtuelle Elemente an die reale Umgebung anpassen.

### Erweiterung 3 – Modulare Hindernisse
- Verschiedene Hindernistypen erstellen.
- Hindernisse als wiederverwendbare Module aufbauen.
- Positionen und Ausrichtungen variieren.
- Kollisionen mit dem Ball berücksichtigen.

### Erweiterung 4 – Automatische Streckengenerierung
- Eine freie Fläche als Grundlage verwenden.
- Start- und Zielposition festlegen.
- Hindernisse passend zum verfügbaren Platz verteilen.
- Sicherstellen, dass die Strecke grundsätzlich spielbar bleibt.

### Erweiterung 5 – Spielkomfort und Präsentation
- Animationen und Soundeffekte ergänzen.
- Weitere Bahnen und Levelwechsel ermöglichen (der einfache Reset ist bereits im MVP enthalten).
- Benutzerfreundliche Hinweise einblenden.
- Gestaltung und visuelle Qualität verbessern.

---

## 9. Definition of Done – erste Version

Die erste Version gilt als fertig, wenn alle folgenden Punkte erfüllt sind:

- [ ] Die bestehende visionOS-App startet nach dem Entfernen ungenutzter Inhalte ohne Fehler.
- [ ] Die immersive Mixed-Reality-Szene wird geöffnet.
- [ ] Ein großer Hebel erscheint nutzerrelativ am Immersive-Space-Ursprung vor dem Spieler.
- [ ] Der Hebel kann auf dem visionOS-Gerät mit der Hand gegriffen werden.
- [ ] Der Hebel lässt sich über Maus-/Trackpad-Drag im Simulator bedienen.
- [ ] Der Hebel lässt sich kontrolliert um die X-Achse bis ~60° ziehen.
- [ ] Beim Erreichen des Auslösewinkels wird das Setup genau einmal erzeugt.
- [ ] Der Hebel kehrt anschließend in die Ausgangsposition zurück.
- [ ] Eine grüne Spielfläche erscheint.
- [ ] Golfschläger, Golfball und Golfloch werden sichtbar.
- [ ] Die Objekte sind unter `setupRoot` sinnvoll zueinander positioniert.
- [ ] Ein zweiter Zug entfernt das Setup und setzt den Zustand auf `ready` zurück.
- [ ] Der komplette Ablauf lässt sich auf Gerät und Simulator beliebig oft vorführen.

**Priorität:** Zuerst eine funktionierende Interaktion, der Reset und eine vollständige Grundszene erreichen. Realistische Modelle, Animationen und spätere Erweiterungen kommen erst danach.
