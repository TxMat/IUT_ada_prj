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
    package p_int_io is new integer_io(integer); use p_int_io; -- integer_io
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

    function checkpossible (coul : in T_coulP) return boolean is
    --Teste si déplacement hg, hd, bg, bd sont possibles
    begin
        return ((Possible(Grille, coul, hg)) or
                (Possible(Grille, coul, hd)) or
                (Possible(Grille, coul, bg)) or
                (Possible(Grille, coul, bd)));
    end checkpossible;

    procedure oppose (dir : in out T_Direction) is
    --Inverse la position de dir :
    -- bg <-> hd; bd <-> hg
    begin
        case dir is
            when hd => dir := bg;
            when hg => dir := bd;
            when bd => dir := hg;
            when bg => dir := hd;
            when others => ecrire_ligne("ERREUR : Direction inexistante");
        end case;
    end

end p_vuetxt;
