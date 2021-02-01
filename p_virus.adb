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
							Grille(i-1,j-1) := coul;	--déplacement vers le haut (ligne-1) et la gauche (colonne -1)
							Grille(i,j) := VIDE; --la case est de nouveau vide

						elsif Dir = hd then
							Grille(i-1,j+1) := coul; --haut (ligne-1), droite (colonne+1)
							Grille(i,j) := VIDE;

						elsif Dir = bg then
							Grille(i+1,j-1) := coul; --bas (ligne+1), droite (colonne-1)
							Grille(i,j) := VIDE;

						else
							Grille(i+1,j+1) := coul; --bas (ligne+1), droite (colonne+1)
							Grille(i,j) := VIDE;
						end if;
					end if;
				end loop;
			end loop;
	end MajGrille;

	function Guerison(Grille : in TV_Grille) return boolean is
	-- {} => {résultat = vrai si Grille(1,A) = Grille(2,B) = ROUGE}
	begin
		return (Grille(1,A) and Grille(2,B)) = ROUGE;
	end Guerison;
end p_virus;
