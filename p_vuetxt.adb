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
    package p_int_io is new integer_io(integer); use p_int_io; -- ???????????
    begin
        ecrire_ligne("     A B C D E F G");
        ecrire_ligne("   S - - - - - - -");
        for i in T_Lig'range loop
            ecrire(image(i) & " |");
            for j in T_Col'range loop
                if Grille(i,j) = VIDE then
                    if (i mod 2 = T_Col'pos(j) mod 2) then
                        ecrire(" .");
                    else
                        ecrire("  ");
                    end if;
                elsif Grille(i,j) = BLANC then
                    ecrire(" F");
                elsif Grille(i,j) in T_Coul then
                    ecrire(T_Coul'pos(Grille(i,j)));
                end if;
            end loop;
            a_la_ligne;
        end loop;
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
