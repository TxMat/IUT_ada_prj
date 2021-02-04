package body p_vue_graph is

procedure creemenu (fmenu : in out TR_fenetre)is

begin
  Fmenu:=DebutFenetre("Menu",400,400);
  -- création des champs/boutons/messages
    AjouterChamp(Fmenu,"ChampNom","Votre Nom","Quentin",120,30,200,30);
    AjouterChamp(Fmenu,"ChampDefi","Numero de defi","1",120,70,200,30);
    AjouterTexte(fmenu,"mesmenu_defi","",95,110,250,30);
    AjouterBouton(Fmenu,"BoutonValider","valider",250,200,75,30);
    AjouterBouton(Fmenu,"BoutonAnnuler","annuler",100,200,75,30);
-- changement des couleurs de fond
    changercouleurfond(fmenu,"BoutonValider",FL_PALEGREEN);
    changercouleurfond(fmenu,"BoutonAnnuler",FL_INDIANRED);
    changercouleurfond(fmenu,"fond",FL_BOTTOM_BCOL);
    changercouleurfond(fmenu,"mesmenu_defi",FL_BOTTOM_BCOL);
-- changement des couleurs de la police
    ChangerCouleurTexte(fmenu,"ChampNom", FL_WHITE);
    ChangerCouleurTexte(fmenu,"ChampDefi", FL_WHITE);
    ChangerCouleurTexte(fmenu,"mesmenu_defi", FL_WHITE);

  FinFenetre(Fmenu);
end creemenu;

procedure AfficheGrille(fGrille : in out TR_fenetre; grille : in tv_grille) is
        ligne, colonne : natural := 0;
        taillebout : positive := 50; --Taille des cases
    begin
    --Création de la Grille
    for l in T_Lig'range loop
      for c in T_Col'range loop

        if Grille(l,c) = VIDE then
          if (l mod 2 = T_Col'pos(c) mod 2) then  --case vide où les pièces peuvent bouger
            AjouterBouton(FGrille,"Case" & image(l) & c," ",70+ligne,100+colonne,taillebout,taillebout);
            ChangerCouleurFond(FGrille,"Case" & image(l) & c,FL_MCOL);
            ChangerEtatBouton(FGrille, "Case" & image(l) & c, Arret);
            ligne:=ligne+taillebout;
          else --case sans rien
            AjouterTexte(FGrille,"Case" & image(l) & c, " ",70+ligne,100+colonne,taillebout,taillebout);
            ChangerCouleurFond(FGrille,"Case" & image(l) & c,FL_LEFT_BCOL);
            ligne:=ligne+taillebout;
          end if;
        elsif Grille(l,c) = BLANC then
          AjouterBouton(FGrille,"Case" & image(l) & c," ",70+ligne,100+colonne,taillebout,taillebout);
          ChangerCouleurFond(FGrille,"Case" & image(l) & c,FL_WHITE);
          ChangerEtatBouton(FGrille, "Case" & image(l) & c, Arret);
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
end AfficheGrille;


procedure creegrille (FGrille : in out TR_fenetre; numd : in integer; nom : in string; grille : in tv_grille) is

begin
    --Fenetre jeu
    FGrille :=DebutFenetre("Grille" & image(numd),650,500);
    AjouterTexte(FGrille, "nomj","Nom du joueur : " & nom,10,10,280,30);
    AjouterTexte(FGrille, "info","Cliquez sur la piece a deplacer.",70,40,280,30);
    AjouterTexte(FGrille, "nbcoups","Nombre de coups : 0",450,100,280,30);

    --Boutons sur le côté
    AjouterBouton(FGrille,"Annul","Annuler le coup",450,140,150,30);
    AjouterBouton(FGrille,"Reset","Recommencer la grille",450,170,150,30);
    AjouterBouton(FGrille,"Quit","Quitter",450,200,150,30);
    ChangerCouleurFond(FGrille,"Annul",FL_SLATEBLUE);
    ChangerCouleurFond(FGrille,"Reset",FL_INDIANRED);
    ChangerCouleurFond(FGrille,"Quit",FL_TOMATO);

    --Création grille de jeu
    AfficheGrille(FGrille,Grille);
    ChangerTexte(FGrille,"Case 1A", "S");
    FinFenetre(FGrille);
end creegrille;


procedure creefin (Ffin : in out TR_fenetre; score : tr_score ) is
  tv_meilleur : TV_Score (1..NB_SCORE_MAX);
begin
  Ffin:=DebutFenetre("Resultats",400,400);
  AjouterTexte(Ffin,"txtnom","joueur " & score.nom,120,30,200,30);
  AjouterTexte(Ffin,"txtdefi","Vous avez battu le defi n°" & integer'image(score.defi),120,70,200,30);
  AjouterTexte(Ffin,"txtnbcoups","Vous avez fait " & integer'image(score.nb_moves) & " mouvements.",120,110,250,30);
  AjouterBouton(Ffin,"Boutonrejouer","rejouer",250,350,75,30);
  AjouterBouton(Ffin,"Boutonquitter","quitter",100,350,75,30);
  -- ajout des couleurs
  changercouleurfond(Ffin,"fond",FL_BOTTOM_BCOL);
  changercouleurfond(Ffin,"txtnom",FL_BOTTOM_BCOL);
  changercouleurfond(Ffin,"txtdefi",FL_BOTTOM_BCOL);
  changercouleurfond(Ffin,"txtnbcoups",FL_BOTTOM_BCOL);
  changercouleurfond(Ffin,"Boutonrejouer",FL_PALEGREEN);
  changercouleurfond(Ffin,"Boutonquitter",FL_INDIANRED);
  -- creation d'un tableau de clasement
  --vv--vv--vv--vv--vv-- en attentente de Quentin --vv--
  tv_meilleur := recup_score(score.defi);
  tri_score(1,tv_meilleur);
  for I in 1..3 loop
   AjouterTexte(Ffin,"txtnomclas" & string(I),tv_meilleur(I).nom & " : " & tv_meilleur(I).temps,80+(I * 70),110,250,30);-- affichage du nom du joueur et du temps
   changercouleurfond(Ffin,"txtnomclas" & string(I),FL_BOTTOM_BCOL)
   AjouterTexte(Ffin,"txtmouvclas" & string(I),tv_meilleur(I).nb_moves & " mouvements.",110+(I * 70),110,250,30); -- affichage du nombre de mouvements
   changercouleurfond(Ffin,"txtmouvclas" & string(I),FL_BOTTOM_BCOL)
  end loop;

end creefin;

procedure Preparation_Grille(FGrille : in out TR_Fenetre; Grille : in TV_Grille; coul : in T_CoulP; lig : in integer; col : in character) is
begin
    if Possible(grille, coul, hg) then
        ChangerCouleurFond(fGrille, "Case" & integer'image(lig - 1) & T_Col'pred(col), FL_PALEGREEN);
        ChangerEtatBouton(FGrille, "Case" & integer'image(lig - 1) & T_Col'pred(col), Marche);
    end if;
    if Possible(grille, coul, bg) then
        ChangerCouleurFond(fGrille, "Case" & integer'image(lig + 1) & T_Col'pred(col), FL_PALEGREEN);
        ChangerEtatBouton(FGrille, "Case" & integer'image(lig + 1) & T_Col'pred(col), Marche);
    end if;
    if Possible(grille, coul, hd) then
        ChangerCouleurFond(fGrille, "Case" & integer'image(lig - 1) & T_Col'succ(col), FL_PALEGREEN);
        ChangerEtatBouton(FGrille, "Case" & integer'image(lig - 1) & T_Col'succ(col), Marche);
    end if;
    if Possible(grille, coul, bd) then
        ChangerCouleurFond(fGrille, "Case" & integer'image(lig + 1) & T_Col'succ(col), FL_PALEGREEN);
        ChangerEtatBouton(FGrille, "Case" & integer'image(lig + 1) & T_Col'succ(col), Marche);
    end if;
    ChangerEtatBouton(FGrille, "Case" & integer'image(lig) & T_Col(col), Arret);
end Preparation_Grille;

end p_vue_graph;
