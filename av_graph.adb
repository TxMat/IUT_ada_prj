with p_vue_graph; use p_vue_graph;
with p_esiut; use p_esiut;
with p_fenbase; use p_fenbase;
with Forms; use Forms;
with sequential_io;
with p_virus; use p_virus;
use p_virus.p_piece_io;

procedure av_graph is

  numd : integer range 1..20 ; -- numero defi
  Fmenu, FGrille, Ffin : TR_fenetre;
  Grille : TV_Grille;
  Pieces : TV_Pieces;
  defichoisie : boolean := false;

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
        begin
           if Bouton /= "Quit" and Bouton /= "Annul" and Bouton /= "Reset" then
               ChangerCouleurFond(Fjeu, Bouton, FL_DEEPPINK);
               I:=Character'Pos(Bouton(Bouton'First)) - Character'Pos('0');
               J:=Character'Pos(Bouton(Bouton'Last)) - Character'Pos('0');
               ecrire_ligne(I);
               ecrire_ligne(J);
           elsif Bouton = "Reset" then
               d
           elsif Bouton = "Annul" then

           elsif Bouton = "Quit" then
               exit;
        end;
    end loop;

end av_graph;
