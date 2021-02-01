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

      put_line("     A B C D E F G");
      put_line("   S - - - - - - -");
      for i in TV_Grille'range(1) loop -- naviguation a travers les lignes de la grille
        put(image(i) & " |");
        for j in TV_Grille'range(2) loop-- naviguation a travers les colonnes de la grille
            --impair = impair
          if Grille(i,j) = VIDE then -- and (i/2 = T_Col'pos(j)/2)
            put(" .");
          elsif Grille(i,j) = BLANC then
            put(" F");
          elsif Grille(i,j) in T_Coul then
            -- u := Integer'image(T_Coul'pos(Grille(i,j)));
            -- ok := u(2);
            ecrire(T_Coul'pos(Grille(i,j)));
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

    procedure annulemouv (grille : in out TV_Grille; dir : in T_Direction; coul : in T_coulP) is

      type TV_ElemP is array (1..3) of TR_ElemP;
      nouv_pos_vect : TV_ElemP; --Stockage des future positions
      counter : integer := 0;

    begin

      for i in TV_Grille'range(1) loop -- navigation a travers les lignes de la grille
        for j in TV_Grille'range(2) loop-- navigation a travers les colonnes de la grille
            if Grille(i,j) = coul then --sélectionne la case avec la pièce de la bonne coul
                          counter := counter+1;
              if Dir = hg then
                              nouv_pos_vect(counter) := (t_col'succ(j), i+1, coul); -- recuperation de l'ancienne pos
                Grille(i,j) := VIDE; --la case est de nouveau vide

              elsif Dir = hd then
                              nouv_pos_vect(counter) := (t_col'pred(j), i+1, coul); -- recuperation de l'ancienne pos
                Grille(i,j) := VIDE;

              elsif Dir = bg then
                              nouv_pos_vect(counter) := (t_col'succ(j), i-1, coul); -- recuperation de l'ancienne pos
                Grille(i,j) := VIDE;

              else
                              nouv_pos_vect(counter) := (t_col'pred(j), i-1, coul); -- recuperation de l'ancienne pos
                Grille(i,j) := VIDE;
              end if;
            end if;
          end loop;
        end loop;
          for i in 1..counter loop
              Grille(nouv_pos_vect(i).ligne,nouv_pos_vect(i).colonne) := coul;
          end loop;

    end annulemouv;
end p_vuetxt;
