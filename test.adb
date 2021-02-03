with p_virus; use p_virus;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
with p_vuetxt; use p_vuetxt;
with text_io; use text_io;
with p_fenbase ; use p_fenbase ;
with Forms ; use Forms;
with p_esiut; use p_esiut;
with ada.calendar; use ada.calendar;

--affichage de la grille:

procedure test is
  Grille : TV_Grille;
  Pieces : TV_Pieces;
  FGrille: TR_Fenetre;

  nom:string(1..20);
  ligne, colonne, NumConf, NBcoups:integer:=0;
  taillebout:integer:=50; --Taille des cases
  f : p_piece_io.file_type;

  subtype T_Col is character range 'A'..'G';
  subtype T_Lig is integer range 1..7;
  type TV_Coul_Graph is array (T_CoulP) of FL_PD_COL;
  Couleur_Bouton: TV_Coul_Graph:=(FL_RED,FL_CYAN,FL_DARKORANGE,FL_MAGENTA,FL_DARKTOMATO,FL_BLUE,FL_DARKVIOLET,FL_CHARTREUSE,FL_YELLOW,FL_WHITE);
begin -- test

  -- put_line("Debut de la phase d'initialisation");
  InitPartie(Grille, Pieces);
  -- put_line("Initialisation terminée");

  InitialiserFenetres;
  open(f, in_file, "Defis.bin");
  ecrire("Conf: "); lire(NumConf);
  ecrire("nom : "); lire(nom);
  Configurer(f, NumConf, Grille, Pieces);

  --Fenetre jeu
  FGrille :=DebutFenetre("Grille" & image(NumConf),650,500);
  AjouterTexte(FGrille, "nomj","Nom du joueur : " & nom,10,10,280,30);
  AjouterTexte(FGrille, "info","Cliquez sur la piece a deplacer.",30,40,280,30);
  AjouterTexte(FGrille, "nbcoups","Nombre de coups : " & image(nbcoups),450,100,280,30);

  --Boutons sur le côté
  AjouterBouton(FGrille,"Annul","Annuler le coup",450,140,150,30);
  AjouterBouton(FGrille,"Reset","Recommencer la grille",450,170,150,30);
  AjouterBouton(FGrille,"Quit","Quitter",450,200,150,30);
  ChangerCouleurFond(FGrille,"Annul",FL_SLATEBLUE);
  ChangerCouleurFond(FGrille,"Reset",FL_INDIANRED);
  ChangerCouleurFond(FGrille,"Quit",FL_TOMATO);

  --Création de la Grille
  for l in T_Lig'range loop
    for c in T_Col'range loop

      if Grille(l,c) = VIDE then
        if (l mod 2 = T_Col'pos(c) mod 2) then
          AjouterBouton(FGrille,"Case" & image(l) & c," ",70+ligne,100+colonne,taillebout,taillebout);
          ChangerCouleurFond(FGrille,"Case" & image(l) & c,FL_MCOL);
          ligne:=ligne+taillebout;
        else
          AjouterTexte(FGrille,"Case" & image(l) & c, " ",70+ligne,100+colonne,taillebout,taillebout);
          ChangerCouleurFond(FGrille,"Case" & image(l) & c,FL_LEFT_BCOL);
          ligne:=ligne+taillebout;
        end if;
      elsif Grille(l,c) = BLANC then
        AjouterBouton(FGrille,"Case" & image(l) & c," ",70+ligne,100+colonne,taillebout,taillebout);
        ChangerCouleurFond(FGrille,"Case" & image(l) & c,FL_WHITE);
        ligne:=ligne+taillebout;
      elsif Grille(l,c)'Valid then
          AjouterBouton(FGrille,"Case" & image(l) & c," ",70+ligne,100+colonne,taillebout,taillebout);
          ChangerCouleurFond(FGrille,"Case" & image(l) & c,Couleur_Bouton(Grille(l,c)));
          ligne:=ligne+taillebout;
      end if;
    end loop;
    colonne:=colonne+taillebout;
    ligne:=0;
  end loop;

  FinFenetre(FGrille);

  MontrerFenetre(FGrille);
  loop
     exit when Attendrebouton(FGrille) = "Quit";  --fermeture de la fenêtre
  end loop;
end test;
