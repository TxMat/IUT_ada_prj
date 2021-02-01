with text_io; use text_io;
with p_esiut; use p_esiut;
with sequential_io;

package body p_virus is

	procedure PosPiece(Grille : in TV_Grille; coul : in T_coulP) is
	-- {} => {la position de la pièce de couleur coul a été affichée, si coul appartient à Grille:
	--				exemple : ROUGE : F4 - G5}


	begin
	ecrire(coul & " : ");
	for i in TV_Grille'range(1) loop -- naviguation a travers les lignes de la grille
		for j in TV_Grille'range(2) loop-- naviguation a travers les colonnes de la grille
				if Grille(i,j) = coul then
					ecrire(image(j) & image(i) & " ");
				end if;
		end loop;
	end loop;

	end PosPiece;

	--------------- Contrôle du jeu

	function Possible(Grille : in TV_Grille; coul : in T_CoulP; Dir : in T_Direction) return boolean is
	-- {coul /= blanc}
	--	=> {resultat = vrai si la pièce de couleur coul peut être déplacée dans la direction Dir}
	begin

	end Possible;

	procedure MajGrille(Grille : in out TV_Grille; coul : in T_CoulP; Dir : in T_Direction) is
	-- {la pièce de couleur coul peut être déplacée dans la direction Dir}
	--	=> {Grille a été mis à jour suite au deplacement}
	begin
		if 
		hg: -1 -1 T_Lig(pos-1) T_Col(pos-1)
		hd: -1 +1 T_Lig(pos-1) T_Col(pos+1)
		bg: +1 -1 T_Lig(pos+1) T_Col(pos-1)
		bd: +1 +1 T_Lig(pos+1) T_Col(pos+1)
	end MajGrille;

	function Guerison(Grille : in TV_Grille) return boolean is
	-- {} => {résultat = vrai si Grille(1,A) = Grille(2,B) = ROUGE}
	begin
		return (Grille(1,A) and Grille(2,B)) = ROUGE;
	end Guerison;
end p_virus;
