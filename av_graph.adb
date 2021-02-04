with p_vue_graph; use p_vue_graph;
with p_esiut; use p_esiut;
with p_fenbase; use p_fenbase;
with Forms; use Forms;
with sequential_io;
with p_virus; use p_virus;
with p_score; use p_score;
use p_virus.p_piece_io;

procedure av_graph is

  numd : integer range 1..20 ; -- numero defi
  Fmenu, FGrille, Ffin : TR_fenetre;
  Score : tr_score;
  Grille : TV_Grille;
  Pieces : TV_Pieces;
  defichoisie : boolean := false;
  f : p_piece_io.file_type;
  Bouton_select_coul : T_coulP;
  premier_coup  : boolean := True;
  Premier_tour : boolean := True;
begin

    InitialiserFenetres;

    --------------- gestion du menu -------------------------
    creemenu(Fmenu);-- procedure créant le Menu
    montrerfenetre(Fmenu);--affichage du Menu

    loop
      declare
        Bouton : String := (Attendrebouton(Fmenu)); -- recuperation du bouton préssé
      begin
        if bouton = "BoutonAnnuler" then --si le bouton annuler est appuié
          cacherfenetre(fmenu); -- on cache la fenetre
        elsif  bouton = "BoutonValider" then --si le bouton Valider est appuié
          -- ici controle de la saisie defi
          declare
            NumDefi: string :=  ConsulterContenu(Fmenu,"ChampDefi"); -- NumDefi prend la valeur de ChampDefi
          begin
            numd := integer'value(NumDefi);-- si le defi n'est pas correct on as une erreur
            defichoisie := true; -- variable permettant de controler la boucle
          exception
            when others => -- l'erreur sugit quand le numero defi n'est pas valide
              changertexte(fmenu,"mesmenu_defi","ce n'est pas un numero de defi"); --affichage d'un messsage pour l'utilisateur
          end;
        end if;
        exit when (bouton = "BoutonValider" and defichoisie ) or bouton = "BoutonAnnuler"; -- sortie si bouton bouton valider et defi correct ou bouton annuler
      end;
    end loop;
    --------------- Fin du Menu -------------------------

    --------------- Debut init grille -------------------
    InitPartie(Grille, Pieces);
    open(f, in_file, "Defis.bin");
    Configurer(f, numd, Grille, Pieces);
    creegrille (FGrille, numd, ConsulterContenu(Fmenu, "ChampNom"),Grille);
    MontrerFenetre(FGrille);
    --------------- Fin init ---------------------------
    while not Guerison(Grille) loop
        declare
           Bouton : String := (Attendrebouton(fGrille));
           Num_col_pred, Num_col_succ : character;
           Num_lig_pred, Num_lig_succ : Integer;
           dir : T_Direction;
           temp : string(1..3);
        begin
           if Bouton /= "Quit" and Bouton /= "Annul" and Bouton /= "Reset" then
               if premier_coup then
                   ChangerCouleurFond(fGrille, Bouton, FL_DEEPPINK);
                   ecrire_ligne(Bouton);
                   temp := Bouton(bouton'last - 1)'image;
                   Num_lig_pred := Integer'Value ((1 => temp(2))); -- ligne 1..7
                   Num_col_pred := Bouton(bouton'last); -- colonne A..G
                   ecrire_ligne("1");
                   ecrire_ligne(premier_coup);
                   Bouton_select_coul := Grille(Num_lig_pred, Num_col_pred);  -- select coul bouton cliqué
                   ecrire_ligne("2");
                   if checkpossible(Grille, Bouton_select_coul) then -- pour eviter de select une piece contrainte
                       Preparation_Grille(FGrille, Grille, Bouton_select_coul, Num_lig_pred, Num_col_pred);
                       premier_coup := False; -- pour passer a la phase 2
                   else
                       ChangerTexte(FGrille, "info", "La piece ne peux pas bouger prenez en une autre");
                   end if;
               else
                   ChangerTexte(FGrille, "info", "Selectionnez la direction souhaitée");
                   ChangerCouleurFond(fGrille, Bouton, FL_DARKVIOLET);
                   ecrire_ligne(Bouton);
                   temp := Bouton(bouton'last - 1)'image;
                   Num_lig_succ := Integer'Value ((1 => temp(2))); -- ligne 1..7
                   Num_col_succ := Bouton(bouton'last); -- colonne A..G
                   dir := Calcul_Dir(Num_lig_pred, Num_lig_succ, Num_col_pred, Num_col_succ); -- calcul dir
                   ecrire("cc");
                   MajGrille(Grille, Bouton_select_coul, dir);
                   AfficheGrille(fGrille, Grille);
                   Premier_coup := False;
                 end if;
           elsif Bouton = "Reset" then
                   Configurer(f, numd, Grille, Pieces);
                   AfficheGrille(fGrille, Grille);
           elsif Bouton = "Annul" then
               if not Premier_tour then
                   oppose(dir);
                   MajGrille(Grille, Bouton_select_coul, dir);
                   ChangerTexte(FGrille, "info", "Mouvement annulé");
               end if;
               ChangerTexte(FGrille, "info", "Vous n'avez pas joué");
           elsif Bouton = "Quit" then
               ChangerTexte(FGrille, "info", "Vous avez quitté le jeu, sortie dans : 3");
               delay 1.0;
               ChangerTexte(FGrille, "info", "Vous avez quitté le jeu, sortie dans : 2");
               delay 1.0;
               ChangerTexte(FGrille, "info", "Vous avez quitté le jeu, sortie dans : 1");
               delay 1.0;
               exit;
           end if;
        end;
    end loop;
    if Guerison(Grille) then
        creefin(FFin, Score);
        MontrerFenetre(FFin);
    end if;
    cacherFenetre(fGrille);
    MontrerFenetre(Fmenu);

end av_graph;
