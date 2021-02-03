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
  NumConf, NBcoups:integer:=0;
  f : p_piece_io.file_type;

  subtype T_Col is character range 'A'..'G';
  subtype T_Lig is integer range 1..7;
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



  FinFenetre(FGrille);

  MontrerFenetre(FGrille);
  loop
     exit when Attendrebouton(FGrille) = "Quit";  --fermeture de la fenêtre
  end loop;
end test;
