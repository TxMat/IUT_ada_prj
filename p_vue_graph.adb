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

end p_vue_graph;
