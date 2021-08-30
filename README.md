# Pick a trek

Repository del sito web [Pick a Trek](https://www.pick-a-trek.it/)

## Brevi riferimenti

```
├── _data/                              # Roba da nerd
├── _includes/                          # Inclusioni comuni per i layouts
├── _layouts/                           # I vari layout per i contenuti
├── _plugins/                           # Plugins
├── _posts/                             # Post del blog
├── _raccolte/                          # Raccolte di sentieri
├── _sass/                              # Stile del tema e stili custom
├── _sentieri/                          # Elenco di sentieri fatti
├── _tabs/                              # Le tab del menu
├── assets/
|   ├── img/ 
|   |   └── galleries/                  # Gallerie di immagini per i sentieri
|   |       └── <single_gallery>        #
├── tools/                              # Tool di varia utilità 
└── README.md                           # Questo README
```

## Updates

- 17/03/2021 -> Traduzione ITA delle date :smirk:

## Mass convert & resize

```bash
magick mogrify -monitor -format jpeg -resize 800x *.heic; rm -rf *.heic
```

## SVG Resources

- https://www.reddit.com/r/webdev/comments/eejh52/websites_i_use_for_free_svg_illustrations/
- https://css-tricks.com/animating-svg-css/
- https://www.manypixels.co/gallery
- https://undraw.co/search
- https://www.humaaans.com/
- https://github.com/SVG-Edit/svgedit
- https://illlustrations.co/
