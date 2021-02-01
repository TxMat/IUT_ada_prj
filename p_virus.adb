with text_io; use text_io;
with p_esiut; use p_esiut;
with sequential_io;

package body p_virus is

	procedure PosPiece(Grille : in TV_Grille; coul : in T_coulP) is
	-- {} => {la position de la pièce de couleur coul a été affichée, si coul appartient à Grille:
	--				exemple : ROUGE : F4 - G5}


	begin
	ecrire(T_coulP'image(coul) & " : ");
	for i in TV_Grille'range(1) loop -- naviguation a travers les lignes de la grille
		for j in TV_Grille'range(2) loop-- naviguation a travers les colonnes de la grille
				if Grille(i,j) = coul then
					ecrire(j & integer'image(i) & " ");
				end if;
		end loop;
	end loop;
	new_line;
	end PosPiece;

	--------------- Contrôle du jeu

	function Possible (Grille : in TV_Grille; coul : T_CoulP; Dir : in T_Direction) return boolean is
		-- {coul /= blanc}
		-- => {résultat = vrai si la pièce de couleur coul peut être déplacée dans la direction Dir}
	rep : boolean := false;
	begin
	for i in TV_Grille'range(1) loop -- naviguation a travers les lignes de la grille
		for j in TV_Grille'range(2) loop-- naviguation a travers les colonnes de la grille
				if Grille(i,j) = coul then
					if Dir = bg then -- deplacement en bas à gauche
						rep := (grille(i+1,t_col'pred(j)) = vide);
					elsif Dir = hg then -- deplacement en haut à gauche
						rep := (grille(i-1,t_col'pred(j)) = vide);
					elsif Dir = bd then -- deplacement en bas à droite
						rep := (grille(i+1,t_col'succ(j)) = vide);
					else -- deplacement en haut à droite
						rep := (grille(i-1,t_col'succ(j)) = vide);
					end if;
				end if;
		end loop;
	end loop;
	return rep ;
	exception
		when constraint_error => -- la piece est collé a un bord
			return false; -- on ne peux donc pas la deplace

	end Possible;


	procedure MajGrille(Grille : in out TV_Grille; coul : in T_CoulP; Dir : in T_Direction) is
	-- {la pièce de couleur coul peut être déplacée dans la direction Dir}
	--	=> {Grille a été mis à jour suite au deplacement}
	begin
		for i in TV_Grille'range(1) loop -- naviguation a travers les lignes de la grille
			for j in TV_Grille'range(2) loop-- naviguation a travers les colonnes de la grille
					if Grille(i,j) = coul then --sélectionne la case avec la pièce de la bonne coul
						if Dir = hg then
							Grille(i-1,t_col'pred(j)) := coul;	--déplacement vers le haut (ligne-1) et la gauche (colonne -1)
							Grille(i,j) := VIDE; --la case est de nouveau vide

						elsif Dir = hd then
							Grille(i-1,t_col'pred(j)) := coul; --haut (ligne-1), droite (colonne+1)
							Grille(i,j) := VIDE;

						elsif Dir = bg then
							Grille(i+1,t_col'pred(j)) := coul; --bas (ligne+1), droite (colonne-1)
							Grille(i,j) := VIDE;

						else
							Grille(i+1,t_col'pred(j)) := coul; --bas (ligne+1), droite (colonne+1)
							Grille(i,j) := VIDE;
						end if;
					end if;
				end loop;
			end loop;
	end MajGrille;

	function Guerison(Grille : in TV_Grille) return boolean is
	-- {} => {résultat = vrai si Grille(1,A) = Grille(2,B) = ROUGE}
	begin
		return (Grille(1,"A") and Grille(2,"B")) = ROUGE;
	end Guerison;

	procedure InitPartie(Grille : in out TV_Grille; Pieces : in out TV_Pieces) is
	-- {} => {Tous les éléments de Grille ont été initialisés avec la couleur VIDE, y compris les cases inutilisables
	--				Tous les élements de Pieces ont été initialisés à false}

    begin
        for i in TV_Grille'range(1) loop
            for j in TV_Grille'range(2) loop
                Grille(i,j) := vide;
            end loop;
        end loop;
        for k in T_coulP'range loop
            Pieces(k) := false;
        end loop;
    end InitPartie;

	procedure Configurer(f : in out p_piece_io.file_type; num : in integer is
											 Grille : in out TV_Grille; Pieces : in out TV_Pieces);
	-- {f ouvert, non vide, num est un numéro de défi
	--	dans f, un défi est représenté par une suite d'éléments :
	--	* les éléments d'une même pièce (même couleur) sont stockés consécutivement
	--	* les deux éléments constituant le virus (couleur rouge) terminent le défi}
	-- 			=> {Grille a été mis à jour par lecture dans f de la configuration de numéro num
	--					Pieces a été mis à jour en fonction des pièces de cette configuration}
        tmp_elem_p_new : TR_ElemP := (T_Col'first, T_Lig'first, T_CoulP'last);
        tmp_elem_p_old : TR_ElemP
        counter : integer := 1;
    begin
        reset(f,in_file);
        while not end_of_file(f) and then not num > counter  loop
            tmp_elem_p_old := tmp_elem_p_new;
            read(f,tmp_elem_p_new);
            if tmp_elem_p_old.couleur = rouge and tmp_elem_p_new.couleur /= rouge then --Tant que défi actuel != défi passé en param, on skip
                counter := counter+1;
            elsif counter = num then
                Grille(tmp_elem_p_new.ligne,tmp_elem_p_new.colonne) := tmp_elem_p_new.couleur; --Placement des pièces sur la grille
                Pieces(tmp_elem_p_new.couleur) := true; --Ajout $tmp_elem_p_new.couleur à la liste des couleurs présentes dans cette config
            end if;
        end loop;
    end Configurer;

	function CaseGrille(lig : in T_lig; col : in T_col) return boolean is
	--	{} => {résultat = vrai si la case en colonne col et en ligne lig est utisable}
	--------------------------------------------------------------------------------------------
		return false;
	end CaseGrille;

	procedure InitMemoG(fg : in out p_grille_io.file_type; G : in out TV_Grille; nbelem : out positive) is
	--{fg ouvert}  =>
	--		{fg a été resetté en position d'écriture, G a été écrit dans fg, nbelem = 1}
	--------------------------------------------------------------------------------------------
	end InitMemoG;
	procedure AddMemoG(fg : in out p_grille_io.file_type; G : in out TV_Grille; nbelem : in out positive) is
	--{fg ouvert, nbelem est le nombre d'éléments de fg}  =>
	--		{G a été ajouté en fin de fg, nbelem a été incrémenté}
	--------------------------------------------------------------------------------------------
	end AddMemoG;
	procedure SupMemoG(fg : in out p_grille_io.file_type; G : in out TV_Grille; nbelem : in out positive) is
	--{fg ouvert, nbelem est le nombre d'éléments de fg, nbelm > 1}  =>
	--		{G = dernier élement de fg, le dernier élément de fg a été supprimé, nbelem est décrémenté}
	--------------------------------------------------------------------------------------------
	end SupMemoG;
end p_virus;
