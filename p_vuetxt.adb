with text_io; use text_io;
with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
with sequential_io;
with ada.characters.latin_1; use ada.characters.latin_1;

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
                elsif Grille(i,j)'valid then
                    put(ESC);
                    put(Code_Couleur(Grille(i,j)));
                    put(" ");
                    put(T_Coul'pos(Grille(i,j)), 0);
                    put(ESC);
                    put("[0m");
                end if;
            end loop;
            a_la_ligne;
        end loop;
    end AfficheGrille;

end p_vuetxt;
