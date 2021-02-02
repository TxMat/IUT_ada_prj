with text_io; use text_io;
with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
with sequential_io;


package p_vuetxt is

    type TV_ElemP is array (1..3) of TR_ElemP;

    procedure AfficheGrille (Grille : in TV_Grille);

    function checkpossible (Grille : in TV_Grille; coul : in T_coulP) return boolean;

    procedure annulemouv (grille : in out TV_Grille; pos_vect : in TV_ElemP; dir : in T_Direction; coul : in T_coulP);

end p_vuetxt;
