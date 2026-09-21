#!/bin/bash

#source_file=${1:?Fichier source manquant} # Fichier source

#echo $source_file





function error {

        echo $*
        exit 1

}






#test -f $source || error  "{$source}: fichier inexistant"
test -f layout/before.html || error "layout/before.html: fichier inexistant"
test -f layout/after.html || error "layout/after.html: fichier inexistant"
test -f output/ || mkdir output


# Actualiser la date de modification des fichiers  fichier

date_modif=$(date)



# Code source du fichier after.html
after_code=$(cat layout/after.html | sed "s/##DATEMODIF##/$date_modif/g")


for source_file in input/*.html; do
        echo "Chemin relatif du fichier source: $source_file"

        file_name="${source_file#input/}"
      
        echo "Construction du fichier $file_name"


        # Titre de la page
        title=$(head -1 $source_file)

        # Supprimer le titre en première ligne du code source du corps du fichier
        source_code=$(cat $source_file | sed "0,/$title/s/$title/\ /")

        echo "Titre du fichier source: $title"

        #  Code source du fichier before.html
        before_code=$(cat layout/before.html | sed "s/##TITRE##/$title/g")


        #echo $date




        # Code final du fichier HTML
        final_code="$before_code$source_code$after_code"
        #echo $final_code





        # Ecrire le code source complet dans le fichier final
        echo $final_code > "output/$file_name"

        echo "Fini de construire output/$file_name"
done


for css_file in input/*.css; do

        echo "Copie de la feuille de style:  ${css_file}"

        file_name="${css_file/input}"

        cp $css_file "output/$file_name"

        echo "Copié la feuille de style dans output/$file_name"


        echo "Terminé la copie des fichiers dans output/"
done
