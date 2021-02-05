package body p_vue_graph is

procedure creemenu (fmenu : in out TR_fenetre)is --fen menu

begin
  Fmenu:=DebutFenetre("Menu",400,400);
  -- création des champs/boutons/messages
    AjouterChamp(Fmenu,"ChampNom","Votre Nom","Quentin",120,30,200,30);
    AjouterChamp(Fmenu,"ChampDefi","Numero de defi","1",120,70,200,30);
    AjouterTexte(fmenu,"mesmenu_defi","",95,110,250,30);
    AjouterBouton(Fmenu,"BoutonValider","Valider",235,200,75,30);
    AjouterBouton(Fmenu,"BoutonAnnuler","Annuler",85,200,75,30);
    AjouterBouton(Fmenu,"Regles","Regles",160,250,75,30);
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

procedure FenetreRegles(FRegles : in out TR_Fenetre) is --page de règles
  NewLine : constant Character := Character'Val (10); -- retour chariot
begin
  FRegles:=DebutFenetre("Regles",400,400);
  AjouterTexte(FRegles,"Titre", "AntiVirus, le jeu !",140,40,150,30);
  AjouterTexte(FRegles,"Regles","AntiVirus est un jeu de logique et de " & NewLine & "resolution de problemes."
                      & NewLine
                      & NewLine & "Le but est de faire sortir le virus (la piece rouge)" & NewLine & "de la cellule (la grille), en l'ammenant" & NewLine & "au coin en haut a gauche, designee par un S."
                      & NewLine & "Les pieces colorees se deplacent en diagonales" & NewLine & "lorsque cela est possible, les pieces blanches" & NewLine & "ne peuvent bouger."
                      & NewLine & "La configuration initiale est determinee par " & NewLine & "un numero de defi, de 1 a 20, niveau croissant."
                      & NewLine & NewLine & "Il faut donc gagner en un minimum de deplacements !", 30, 80, 320, 180);
  AjouterBouton(FRegles,"Ok", "Ok !", 180, 270, 40, 30);
  ChangerStyleContenu(FRegles, "Titre", FL_BOLD_STYLE);
  ChangerTailleTexte(FRegles, "Titre", FL_MEDIUM_SIZE);
  ChangerCouleurFond(FRegles, "Ok", FL_CHARTREUSE);

  FinFenetre(FRegles);
end FenetreRegles;

procedure creegrille (FGrille : in out TR_fenetre; numd : in integer; nom : in string; grille : in tv_grille) is --fen jeu

begin
  --Fenetre jeu
  FGrille :=DebutFenetre("Grille" & image(numd),650,500);
  AjouterTexte(FGrille, "nomj","Nom du joueur : " & nom,10,10,280,30);
  AjouterTexte(FGrille, "info","Bienvenue ! Cliquez sur une piece pour la deplacer.",70,60,450,30);
  AjouterTexte(FGrille, "nbcoups","Nombre de coups : 0",450,100,280,30);

  --Boutons sur le côté
  AjouterBouton(FGrille,"Annul","Annuler le coup",450,140,150,30);
  AjouterBouton(FGrille,"Reset","Recommencer la grille",450,180,150,30);
  AjouterBouton(FGrille,"Quit","Quitter",450,260,150,30);
  ChangerCouleurFond(FGrille,"Annul",FL_SLATEBLUE);
  ChangerCouleurFond(FGrille,"Reset",FL_INDIANRED);
  ChangerCouleurFond(FGrille,"Quit",FL_TOMATO);

  --Création grille de jeu
  AfficheGrille(FGrille,Grille,0);
  ChangerTexte(FGrille,"Case 1A", "S");
  FinFenetre(FGrille);
end creegrille;

procedure AfficheGrille(fGrille : in out TR_fenetre; grille : in tv_grille; nbcoups: in integer) is
        ligne, colonne : natural := 0;
        taillebout : constant positive := 50; --Taille des cases
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
            ChangerEtatBouton(FGrille, "Case" & image(l) & c, Marche);
            ligne:=ligne+taillebout;
        end if;
      end loop;
      colonne:=colonne+taillebout;
      ligne:=0;
    end loop;
    ChangerTexte(FGrille,"nbcoups","Nombre de coups :" & image(nbcoups));
    ChangerStyleContenu(FGrille,"nbcoups",FL_BOLD_STYLE);
end AfficheGrille;


procedure creefin (Ffin : in out TR_fenetre; score : in out TR_Score ) is    --fen résultats
    tv_meilleur : TV_Score (1..NB_SCORE_MAX);
begin
    Ffin:=DebutFenetre("Resultats",400,400);
    AjouterTexte(Ffin,"txtnom","Joueur : " & score.nom,50,20,200,30);
    AjouterTexte(Ffin,"txtdefi","Vous avez battu le defi n'" & integer'image(score.defi),50,50,200,30);
    AjouterTexte(Ffin,"txtnbcoups","Vous avez fait" & integer'image(score.nb_moves) & " mouvements.",50,70,250,30);
    AjouterTexte(Ffin,"class", "Voici les scores precedents :", 50,100,250,30);
    AjouterBouton(Ffin,"Boutonrejouer","Rejouer",235,350,75,30);
    AjouterBouton(Ffin,"Boutonquitter","Quitter",85,350,75,30);
    -- ajout des couleurs et mise en forme
    changercouleurfond(Ffin,"fond",FL_BOTTOM_BCOL);
    changercouleurfond(Ffin,"txtnom",FL_BOTTOM_BCOL);
    changercouleurfond(Ffin,"txtdefi",FL_BOTTOM_BCOL);
    changercouleurfond(Ffin,"txtnbcoups",FL_BOTTOM_BCOL);
    changercouleurfond(Ffin,"class",FL_BOTTOM_BCOL);
    changercouleurfond(Ffin,"Boutonrejouer",FL_PALEGREEN);
    changercouleurfond(Ffin,"Boutonquitter",FL_INDIANRED);
    ChangerStyleContenu(Ffin,"class",FL_BOLD_STYLE);
    -- creation d'un tableau de clasement
    --vv--vv--vv--vv--vv-- avec le reuf Quentin --vv--
    ajout_score(Score);
    tv_meilleur := recup_score(score.defi);
    tri_score(nb_coups,tv_meilleur);

    for I in 1..3 loop
        ecrire_ligne("indice n°"&image(i));
        ecrire_ligne("défi : " &image(tv_meilleur(i).defi));
        ecrire_ligne("nom : " &tv_meilleur(i).nom);
        ecrire_ligne("temps : ");
        ecrire_ligne("moves : "&image(tv_meilleur(i).nb_moves));
        a_la_ligne;
        AjouterTexte(Ffin,"txtnomclas" & image(I),tv_meilleur(I).nom & " : " & Float'Image(tv_meilleur(I).temps),90,(60+(I * 70)),250,30);-- affichage du nom du joueur et du temps
        changercouleurfond(Ffin,"txtnomclas" & image(I),FL_BOTTOM_BCOL);
        AjouterTexte(Ffin,"txtmouvclas" & image(I),image(tv_meilleur(I).nb_moves) & " mouvements.",90,(90+(I * 70)),250,30); -- affichage du nombre de mouvements
        changercouleurfond(Ffin,"txtmouvclas" & image(I),FL_BOTTOM_BCOL);
  end loop;
  FinFenetre(ffin);
end creefin;

procedure Preparation_Grille(FGrille : in out TR_Fenetre; Grille : in TV_Grille; coul : in T_CoulP; lig : in integer; col : in character) is

begin
    for l in T_Lig'range loop
      for c in T_Col'range loop
          ChangerEtatBouton(FGrille, "Case" & image(l) & c, Arret);
      end loop;
    end loop;

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
