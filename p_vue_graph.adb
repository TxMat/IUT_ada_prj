package body p_vue_graph is

procedure creemenu (fmenu : in out TR_fenetre)is

begin
  Fmenu:=DebutFenetre("Menu",400,400);
  -- création des champ/bouton/message
    AjouterChamp(Fmenu,"ChampNom","Votre Nom","Quentin",120,30,200,30);
    AjouterChamp(Fmenu,"ChampDefi","Numero de defi","1",120,70,200,30);
    AjouterTexte(fmenu,"mesmenu_defi","",95,110,250,30);
    AjouterBouton(Fmenu,"BoutonValider","valider",250,200,75,30);
    AjouterBouton(Fmenu,"BoutonAnnuler","annuler",100,200,75,30);
-- changement des couleur de fond
    changercouleurfond(fmenu,"BoutonValider",FL_PALEGREEN);
    changercouleurfond(fmenu,"BoutonAnnuler",FL_INDIANRED);
    changercouleurfond(fmenu,"fond",FL_BOTTOM_BCOL);
    changercouleurfond(fmenu,"mesmenu_defi",FL_BOTTOM_BCOL);
-- changement des la couleur de la police
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
    AfficheGrille(FGrille,Grille);
    FinFenetre(FGrille);
end creegrille;


procedure creefin (Ffin : in out TR_fenetre; score : tr_score ) is

begin
  Ffin:=DebutFenetre("Resultats",400,400);
  -- création des champ/bouton/
  AjouterTexte(Ffin,"txtnom","joueur " & score.nom,120,30,200,30);
  AjouterTexte(Ffin,"txtdefi","Vous avez battu le defi n°" & integer'image(score.defi),120,70,200,30);
  AjouterTexte(Ffin,"txtnbcoups","Vous avez fait " & integer'image(score.nb_moves) & " mouvements.",120,110,250,30);
  AjouterBouton(Ffin,"Boutonrejouer","rejouer",250,200,75,30);
  AjouterBouton(Ffin,"Boutonquitter","quitter",100,200,75,30);


end creefin;

function checkpossible (Grille : in TV_Grille; coul : in T_coulP) return boolean is
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
end oppose;

end p_vue_graph;
