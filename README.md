# CA80 jako sterownik pralki automatycznej.

Lata osiemdziesiąte przyniosły nowe możliwości. 
Mimo kryzysu i braku wszystkiego, próbowano unowocześniać sprzęty AGD.

Od mojego nauczyciela podstaw automatyki dostałem teczkę z kompletnym projektem modernizacji pralki [PS 663 S bio](https://pl.wikipedia.org/wiki/Polar_PS_663_Bio). 
Był tam schemat elektryczny, szkice stanów programatora mechanicznego, "karta badań kontrolno-odbiorczych pralki typ 663 S bio" oraz wystukany na maszynie do pisania program dla CA80. 
Jakimś cudem wszystko ocalało i przeleżało prawie czterdzieści lat w kartonie z książkami. Miałem taką pralkę, więc też próbowałem wykorzystać te materiały, ale czas zweryfikował moje plany.

Zrobiłem skan projektu, żeby go ocalić dla potomnych, bo prawdopodobnie jest to najstarszy w Polsce "embedded". 

## Unikalny program napisany na maszynie do pisania.

Przepisałem program w edytorze i przy okazji zmieniłem mnemoniki rozkazów na Z80 (były Intela 8080). 
Pierwsze programy też pisałem "Intelem", bo nie miałem żadnego nowszego podręcznika. Oczywiście zrobiłem kilka błędów, ale szybko się z nimi uporałem. 
Żeby sprawdzić, czy działa, będę musiał zbudować jakiś model, bo takiej pralki z pewnością nie znajdę.
Program jest napisany "blokująco", bo jest wierną kopią mechanicznego programatora.
Kolejne kroki działają tak, jak w pierwowzorze.
