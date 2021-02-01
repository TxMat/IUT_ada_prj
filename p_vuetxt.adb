with text_io; use text_io;
with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
with sequential_io;

package body p_vuetxt is

    procedure AfficheGrille (Grille : in TV_Grille) is
    -- {} => {la grille a été affichée selon les spécifications suivantes :
    -- * la sortie est indiquée par la lettre S
    -- * une case inactive ne contient aucun caractère
    -- * une case de couleur vide contient un point
    -- * une case de couleur blanche contient le caractère F (Fixe)
    -- * une case de la couleur d’une pièce mobile contient le chiffre correspondant à la
    -- position de cette couleur dans le type T_Coul}
    package p_int_io is new integer_io(integer); use p_int_io;
        u : string(1..2);
        ok : character;
    begin

      put_line("    A B C D E F G");
      put_line("  S - - - - - - -");
      for i in TV_Grille'range(1) loop -- naviguation a travers les lignes de la grille
        put(image(i) & " | ");
        for j in TV_Grille'range(2) loop-- naviguation a travers les colonnes de la grille
          if Grille(i,j) = VIDE then
            put(".");
          elsif Grille(i,j) = BLANC then
            put("F");
          elsif Grille(i,j) in T_Coul then
            u := Integer'image(T_Coul'pos(Grille(i,j)));
            ok := u(2);
            ecrire(ok);
          else
            put(" ");
          end if;
        end loop;
        new_line;
      end loop;

      -- put("2 | ");
      -- put("3 | ");
      -- put("4 | ");
      -- put("5 | ");
      -- put("6 | ");
      -- put("7 | ");
    end AfficheGrille;
end p_vuetxt;
