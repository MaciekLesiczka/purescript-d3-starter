var gulp = require("gulp");
var purescript = require("gulp-purescript");
var browserSync = require('browser-sync');

var sources = [
  "src/**/*.purs",
  "bower_components/purescript-*/src/**/*.purs",
];

var foreigns = [
  "src/**/*.js",
  "bower_components/purescript-*/src/**/*.js"
];

gulp.task("make", function () {
  return purescript.psc({ src: sources, ffi: foreigns });
});

var bundle = function(){
  return purescript.pscBundle({ src: "output/**/*.js", output: "dist/bundle.js", main:"Main"});
}

gulp.task("bundle", function () {
  return bundle();
});

gulp.task("build", ["make"], function () {
  return bundle();
});

gulp.task('serve', ["build"], function() {
  browserSync({
    server: {
      baseDir: 'dist'
    }
  });
	gulp.watch(['dist/**/*.html'], {cwd: '.'}, browserSync.reload);
  gulp.watch(['output/Main/index.js'], {cwd: '.'}, function(){
      return gulp.start('js-reload')
  });
});
gulp.task('js-reload', ["bundle"], browserSync.reload);


gulp.task("default", ["serve"]);
