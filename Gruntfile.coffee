names = ['intro', 'app', 'events', 'geom', 'note', 'playhead', 'main']
paths = ("src/#{name}.coffee" for name in names)

contribs = ['stylus', 'watch', 'coffee']

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    banner: "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - " + "<%= grunt.template.today(\"yyyy-mm-dd\") %>\n" + "<%= pkg.homepage ? \"* \" + pkg.homepage + \"\\n\" : \"\" %>" + "* Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author.name %>;" + " Licensed <%= _.pluck(pkg.licenses, \"type\").join(\", \") %> */\n"

    concat:
      options:
        banner: "<%= banner %>"
        stripBanners: true

      dist:
        src: ["lib/<%= pkg.name %>.js"]
        dest: "dist/<%= pkg.name %>.js"

    uglify:
      options:
        banner: "<%= banner %>"

      dist:
        src: "<%= concat.dist.dest %>"
        dest: "dist/<%= pkg.name %>.min.js"

    jshint:
      options:
        curly: true
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noarg: true
        sub: true
        undef: true
        unused: true
        boss: true
        eqnull: true
        browser: true
        globals: {}

      gruntfile:
        src: "Gruntfile.js"

      lib_test:
        src: [
          "lib/**/*.js"
          "test/**/*.js"
        ]

    qunit:
      files: ["test/**/*.html"]

    watch:
      gruntfile:
        files: "<%= jshint.gruntfile.src %>"
        tasks: ["jshint:gruntfile"]

      lib_test:
        files: ['src/*', 'stylus/*']
        tasks: ['default']

    connect:
      server:
        options:
          port: 9000
          base: 'site'
          keepalive: true

    stylus:
      compile:
        expand: true
        cwd: 'stylus'
        src: ['*.styl']
        dest: 'css/'
        ext: '.css'

    coffee:
      compile:
        options:
          join: true
        files:
          'js/main.js': paths

  grunt.loadNpmTasks("grunt-contrib-#{contrib}") for contrib in contribs
  grunt.loadNpmTasks('grunt-connect')

  # Default task.
  grunt.registerTask "default", ['coffee', 'stylus']
