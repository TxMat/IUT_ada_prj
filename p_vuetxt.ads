with text_io; use text_io;
with p_virus; use p_virus;
with p_esiut; use p_esiut;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
with sequential_io;


package p_vuetxt is

    procedure AfficheGrille (Grille : in TV_Grille);

    procedure annulemouv (grille : in out TV_Grille; dir : T_Direction; coul : in T_coulP);
end p_vuetxt;
