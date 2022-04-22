with text_io; use text_io;
with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
with sequential_io;


package p_vuetxt is


	type TV_Code_Coul is array (T_CoulP) of String(1..10);
	Code_Couleur: TV_Code_Coul := ("[38;5;196m", "[38;5;033m", "[38;5;202m", "[38;5;206m", "[38;5;052m", "[38;5;021m", "[38;5;055m", "[38;5;028m", "[38;5;220m", "[38;5;231m");

    type TV_ElemP is array (1..3) of TR_ElemP;

    procedure AfficheGrille (Grille : in TV_Grille);

    function checkpossible (Grille : in TV_Grille; coul : in T_coulP) return boolean;

    procedure oppose (dir : in out T_Direction);

end p_vuetxt;
