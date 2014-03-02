favicon:
	convert -resize x16 img/bird.png favicon.ico

build: favicon
	rsync -Rr \
	    index.html \
	    favicon.ico \
	    css/main.css \
	    vendor/bootstrap/dist/css/bootstrap.css \
	    vendor/bootstrap/dist/fonts \
	    js/main.js \
	    data \
	    img/bird.png \
	    vendor/jquery/dist/jquery.js \
	    vendor/bootstrap/dist/js/bootstrap.js \
	    vendor/Audiolet/src/audiolet/Audiolet.js \
	    vendor/two/build/two.js \
	    site

deploy: build
	s3cmd sync site/ s3://chirrup --acl-public
