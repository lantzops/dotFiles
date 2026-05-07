#!/bin/bash

# Set up image file associations to open with Eye of GNOME
xdg-mime default org.gnome.eog.desktop image/jpeg
xdg-mime default org.gnome.eog.desktop image/jpg
xdg-mime default org.gnome.eog.desktop image/png
xdg-mime default org.gnome.eog.desktop image/gif
xdg-mime default org.gnome.eog.desktop image/webp
xdg-mime default org.gnome.eog.desktop image/avif
xdg-mime default org.gnome.eog.desktop image/tiff
xdg-mime default org.gnome.eog.desktop image/x-tiff
xdg-mime default org.gnome.eog.desktop image/bmp
xdg-mime default org.gnome.eog.desktop image/x-bmp
xdg-mime default org.gnome.eog.desktop image/x-portable-bitmap
xdg-mime default org.gnome.eog.desktop image/svg+xml
xdg-mime default org.gnome.eog.desktop image/x-dcraw

# Set up video file associations to open with mpv
xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/x-mp4
xdg-mime default mpv.desktop video/mov
xdg-mime default mpv.desktop video/quicktime
xdg-mime default mpv.desktop video/x-m4v
xdg-mime default mpv.desktop video/avi
xdg-mime default mpv.desktop video/msvideo
xdg-mime default mpv.desktop video/x-msvideo
xdg-mime default mpv.desktop video/x-avi
xdg-mime default mpv.desktop video/x-flv
xdg-mime default mpv.desktop video/flv
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop video/x-matroska
xdg-mime default mpv.desktop video/matroska
xdg-mime default mpv.desktop video/x-ms-wmv
xdg-mime default mpv.desktop application/x-mpeg
xdg-mime default mpv.desktop video/3gpp
xdg-mime default mpv.desktop video/3gp
xdg-mime default mpv.desktop video/3g2
xdg-mime default mpv.desktop video/mp2t
xdg-mime default mpv.desktop video/mpeg

# Set up PDF and ebook associations to open with Okular
xdg-mime default org.kde.okular.desktop application/pdf
xdg-mime default org.kde.okular.desktop application/x-pdf
xdg-mime default org.kde.okular.desktop application/epub+zip
xdg-mime default org.kde.okular.desktop application/x-epub+zip
xdg-mime default org.kde.okular.desktop application/x-mobipocket-ebook
xdg-mime default org.kde.okular.desktop application/epub

echo "MIME type associations updated successfully!"