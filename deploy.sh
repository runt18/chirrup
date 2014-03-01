rsync -Rr \
    index.html \
    css/main.css \
    vendor/bootstrap/dist/css/bootstrap.css \
    vendor/bootstrap/dist/fonts \
    js/main.js \
    data \
    vendor/jquery/dist/jquery.js \
    vendor/bootstrap/dist/js/bootstrap.js \
    vendor/two/build/two.js \
    vendor/timbre/timbre.dev.js \
    site

s3cmd sync site/ s3://chirrup --acl-public
